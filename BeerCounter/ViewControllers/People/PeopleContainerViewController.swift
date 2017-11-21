//
//  PeopleContainerViewController.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PeopleContainerViewController: UIViewController {
    
    private var loginButton: UIBarButtonItem?
    
    var isAdminLoggedIn = false {
        didSet {
            setupLoginButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

private extension PeopleContainerViewController {
    
    func setupUI() {
        navigationItem.title = "People"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPersonTapped))
        
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.adminLoginTapped))
        navigationItem.leftBarButtonItem = button
        loginButton = button
        
        setupLoginButton()
    }
    
    func setupLoginButton() {
        loginButton?.title = isAdminLoggedIn ? "Log Out" : "Login"
    }
    
    @objc func addPersonTapped() {
        addPerson(sender: self)
    }
    
    @objc func adminLoginTapped() {
        toggleAdminLogin(sender: self)
    }
}
