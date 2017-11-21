//
//  AppCoordinator.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit
import MultipeerConnectivity

final class AppCoordinator: ContainerCoordinator<UIViewController>, NeedsDependency {
    
    enum Content {
        case people
    }
    
    var dependencies: AppDependency? {
        didSet {
            updateChildCoordinatorDependencies()
            processQueuedMessages()
        }
    }
    
    private var content: Content = .people
    
    override func start(with completion: @escaping () -> Void = {}) {
        let multipeer = MultipeerManager(delegate: self)
        let dataManager = DataManager(multiPeerManager: multipeer)
        let peopleManager = PeopleManager(dataManager: dataManager)
        let userManager = UserManager()
        
        dependencies = AppDependency(dataManager: dataManager,
                                     peopleManager: peopleManager,
                                     userManager: userManager,
                                     multipeerManager: multipeer)

        super.start(with: completion)
        
        setup(forContent: content)
    }

}

extension AppCoordinator: MultipeerManagerDelegate {
    
    func didReceivedData(_ data: Data, manager: MultipeerManager) {
        dependencies?.dataManager?.updateDatabase(withData: data)
        dependencies?.peopleManager?.fetch(completion: { [weak self] _ in
            self?.updateChildCoordinatorDependencies()
        })
    }
    
    func sendDataToPeer(_ peer: MCPeerID, manager: MultipeerManager) {
        dependencies?.dataManager?.distributeDatabase(toPeer: peer)
    }
}

private extension AppCoordinator {
    
    func setup(forContent content: Content) {
        self.content = content
        
        switch content {
        case .people:
            showPeople()
        }
    }

    func showPeople() {
        let coordinator: PeopleSplitCoordinator
        
        let identifier = String(describing: PeopleSplitCoordinator.self)
        if let coord = childCoordinators[identifier] as? PeopleSplitCoordinator {
            coordinator = coord
        }
        else {
            coordinator = PeopleSplitCoordinator()
        }
        
        coordinator.dependencies = dependencies
        startChild(coordinator: coordinator)
        
        embed(controller: coordinator.rootViewController)
    }
}
