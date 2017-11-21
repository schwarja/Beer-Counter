//
//  PeopleNavigationCoordinator.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PeopleNavigationCoordinator: NavigationCoordinator, NeedsDependency {
    
    var dependencies: AppDependency? {
        didSet {
            updateChildCoordinatorDependencies()
        }
    }

    var state: ControllerState<([Person], Person?)> = .loading {
        didSet {
            let identifier = String(describing: PeopleCoordinator.self)
            if let coordinator = childCoordinators[identifier] as? PeopleCoordinator {
                coordinator.state = state
            }
        }
    }

    init() {
        let people = PeopleCoordinator()
        let navigation = UINavigationController(rootViewController: people.rootViewController)
        super.init(rootViewController: navigation)
        
        startChild(coordinator: people)
    }
}
