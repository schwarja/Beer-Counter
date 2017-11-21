//
//  NavigationCoordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

open class NavigationCoordinator: Coordinator<UINavigationController>, UINavigationControllerDelegate {
	//	this keeps the references to actual UIViewControllers managed by this Coordinator only
    open var viewControllers: [UIViewController] {
        return rootViewController.viewControllers
    }

	public override init(rootViewController: UINavigationController?) {
		super.init(rootViewController: rootViewController)
	}

	public func present(_ vc: UIViewController) {
		rootViewController.present(vc, animated: true, completion: nil)
	}

	public func show(_ vc: UIViewController) {
		rootViewController.show(vc, sender: self)
	}

	public func root(_ vc: UIViewController) {
		rootViewController.viewControllers = [vc]
	}

	public func pop(to vc: UIViewController, animated: Bool = true) {
		rootViewController.popToViewController(vc, animated: animated)
	}

	open override func start(with completion: @escaping () -> Void) {
		rootViewController.delegate = self
		super.start(with: completion)
	}

	open override func stop(with completion: @escaping () -> Void) {
		rootViewController.delegate = nil
		super.stop(with: completion)
	}
}


