//
//  PersonViewController.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PersonCoordinator: ContainerCoordinator<PersonContainerViewController>, NeedsDependency {
    
    var dependencies: AppDependency? {
        didSet {
            updateChildCoordinatorDependencies()
            updateContent()
        }
    }

    var state: ControllerState<Person> = .loading {
        didSet {
            updateContent()
        }
    }

    init() {
        let root = PersonContainerViewController(nibName: nil, bundle: nil)
        super.init(rootViewController: root)
    }
}

private extension PersonCoordinator {
    
    func updateContent() {
        switch state {
        case .empty:
            let controller: PersonEmptyViewController
            if let embedded = embededController as? PersonEmptyViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonEmptyViewController") as! PersonEmptyViewController
                embed(controller: controller)
            }
            controller.text = "No person selected"
            rootViewController.person = nil
            
        case .error(let error):
            let controller: PersonEmptyViewController
            if let embedded = embededController as? PersonEmptyViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonEmptyViewController") as! PersonEmptyViewController
                embed(controller: controller)
            }
            controller.text = error?.localizedDescription ?? "Error occured"
            rootViewController.person = nil

        case .showData(let person):
            let controller: PersonContentViewController
            if let embedded = embededController as? PersonContentViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonContentViewController") as! PersonContentViewController
                embed(controller: controller)
            }
            controller.person = person
            controller.canResetCounter = dependencies?.userManager?.isAdmin ?? false
            controller.isLoading = false
            rootViewController.person = person

        case .loading:
            let controller: PersonContentViewController
            if let embedded = embededController as? PersonContentViewController {
                controller = embedded
            }
            else {
                controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonContentViewController") as! PersonContentViewController
                embed(controller: controller)
            }
            controller.isLoading = true
            rootViewController.person = nil
        }
    }
}
