//
//  ContainerCoordinator.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

open class ContainerCoordinator<T: UIViewController>: Coordinator<T> {
    
    internal var embededController: UIViewController?

    public override init(rootViewController: T?) {
        super.init(rootViewController: rootViewController)
    }
    
    public func present(_ vc: UIViewController) {
        rootViewController.present(vc, animated: true, completion: nil)
    }
    
    func embed(controller: UIViewController) {
        if let controller = embededController {
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
        
        rootViewController.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        rootViewController.view.addSubview(controller.view)
        
        rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]|", options: [], metrics: nil, views: ["content": controller.view]))
        rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[content]|", options: [], metrics: nil, views: ["content": controller.view]))

        controller.didMove(toParentViewController: rootViewController)
        
        embededController = controller
    }
}

