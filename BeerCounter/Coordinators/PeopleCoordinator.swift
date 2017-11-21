//
//  PeopleViewController.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PeopleCoordinator: ContainerCoordinator<PeopleContainerViewController>, NeedsDependency {
    
    var dependencies: AppDependency? {
        didSet {
            updateChildCoordinatorDependencies()
            updateContent()
        }
    }

    var state: ControllerState<([Person], Person?)> = .loading {
        didSet {
            updateContent()
        }
    }
    
    init() {
        let root = PeopleContainerViewController(nibName: nil, bundle: nil)
        super.init(rootViewController: root)
    }
}

private extension PeopleCoordinator {
    
    func updateContent() {
        rootViewController.isAdminLoggedIn = dependencies?.userManager?.isAdmin ?? false
        
        switch state {
        case .empty:
            let controller: PeopleEmptyViewController
            if let embedded = embededController as? PeopleEmptyViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeopleEmptyViewController") as! PeopleEmptyViewController
                embed(controller: controller)
            }
            controller.text = "Nothing to show"
            
        case .error(let error):
            let controller: PeopleEmptyViewController
            if let embedded = embededController as? PeopleEmptyViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeopleEmptyViewController") as! PeopleEmptyViewController
                embed(controller: controller)
            }
            controller.text = error?.localizedDescription ?? "Error occured"
            
        case .showData(let tuple):
            let controller: PeopleContentViewController
            if let embedded = embededController as? PeopleContentViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeopleContentViewController") as! PeopleContentViewController
                embed(controller: controller)
            }
            controller.people = tuple.0
            controller.canDeletePeople = dependencies?.userManager?.isAdmin ?? false
            controller.selectedPerson = tuple.1
            
        case .loading:
            if !(embededController is PeopleLoadingViewController) {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeopleLoadingViewController") as! PeopleLoadingViewController
                embed(controller: controller)
            }
        }
    }
}
