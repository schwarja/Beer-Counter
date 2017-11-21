//
//  NavigationCoordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

open class SplitViewCoordinator: Coordinator<UISplitViewController> {

    open var viewControllers: [UIViewController] {
        return rootViewController.viewControllers
    }

	public override init(rootViewController: UISplitViewController?) {
		super.init(rootViewController: rootViewController)
	}

	public func present(_ vc: UIViewController) {
		rootViewController.present(vc, animated: true, completion: nil)
	}
    
    public func showDetail(_ vc: UIViewController) {
        vc.parentCoordinator = self
        rootViewController.showDetailViewController(vc, sender: self)
    }
    
    open override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
    }
    
    open override func stop(with completion: @escaping () -> Void) {
        rootViewController.delegate = nil
        super.stop(with: completion)
    }
}


