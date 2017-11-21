//
//  PeopleCoordinator.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

final class PeopleSplitCoordinator: SplitViewCoordinator, NeedsDependency, UISplitViewControllerDelegate {
    
    private var selectedPerson: Person?
    private var state: ControllerState<([Person], Person?)> = .loading
    
    private var alertTextField: UITextField?
    
    var dependencies: AppDependency? {
        didSet {
            updateChildCoordinatorDependencies()
            fetchPeople()
        }
    }
    
    init() {
        let splitView = UISplitViewController(nibName: nil, bundle: nil)
        let master = PeopleNavigationCoordinator()
        let detail = PersonCoordinator()
        splitView.viewControllers = [master.rootViewController, detail.rootViewController]
        splitView.preferredDisplayMode = .allVisible
        super.init(rootViewController: splitView)
        
        startChild(coordinator: master)
        startChild(coordinator: detail)
    }
    
    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
        rootViewController.delegate = self
        
        fetchPeople()
    }
    
    override func toggleAdminLogin(sender: Any?) {
        if dependencies?.userManager?.isAdmin ?? false {
            dependencies?.userManager?.logout(completion: { [weak self] (error) in
                if error == nil {
                    self?.updateChildCoordinatorDependencies()
                }
            })
        }
        else {
            presentInputAlert(withTitle: "Enter password", isInputSecured: true) { [weak self] (success, password) in
                if success {
                    self?.dependencies?.userManager?.login(withPassword: password, completion: { (error) in
                        if let error = error {
                            self?.presentErrorMessage(error.localizedDescription)
                        }
                        else {
                            self?.updateChildCoordinatorDependencies()
                        }
                    })
                }
            }
        }
    }
    
    override func showPerson(person: Person, sender: Any?) {
        selectedPerson = person
        if case .showData(let tuple) = state {
            state = .showData(data: (tuple.0, selectedPerson))
            updateChildCoordinators(withState: state)
        }
        if let coordinator = childCoordinators[String(describing: PersonCoordinator.self)] as? PersonCoordinator {
            showDetail(coordinator.rootViewController)
        }
    }
    
    override func addPerson(sender: Any?) {
        presentInputAlert(withTitle: "Enter name", isInputSecured: false) { [weak self] (success, name) in
            if success, let name = name, !name.isEmpty {
                self?.dependencies?.peopleManager?.addPerson(name: name, completion: { [weak self] (error) in
                    if error == nil {
                        self?.fetchPeople()
                    }
                })
            }
        }
    }
    
    override func deletePerson(person: Person, sender: Any?) {
        self.dependencies?.peopleManager?.deletePerson(person, completion: { [weak self] (error) in
            if error == nil {
                self?.fetchPeople()
            }
        })
    }
    
    override func addBeer(toPerson person: Person, sender: Any?) {
        state = .loading
        updateChildCoordinators(withState: state)
        dependencies?.peopleManager?.addBeer(toPerson: person, completion: { (error) in
            if error == nil {
                fetchPeople()
            }
        })
    }
    
    override func subtractBeer(forPerson person: Person, sender: Any?) {
        state = .loading
        updateChildCoordinators(withState: state)
        dependencies?.peopleManager?.subtractBeer(forPerson: person, completion: { (error) in
            if error == nil {
                fetchPeople()
            }
        })
    }
    
    override func resetBeerCount(forPerson person: Person, sender: Any?) {
        state = .loading
        updateChildCoordinators(withState: state)
        dependencies?.peopleManager?.resetBeerCount(forPerson: person, completion: { (error) in
            if error == nil {
                fetchPeople()
            }
        })
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}

private extension PeopleSplitCoordinator {
    
    func fetchPeople() {
        dependencies?.peopleManager?.fetch(completion: { [weak self] (error) in
            let state: ControllerState<([Person], Person?)>
            
            if let person = selectedPerson, let index = dependencies?.peopleManager?.people.index(where: { person.id == $0.id }) {
                selectedPerson = dependencies?.peopleManager?.people[index]
            }
            else {
                selectedPerson = dependencies?.peopleManager?.people.first
            }
            
            if let error = error {
                state = .error(error: error)
            }
            else if self?.dependencies?.peopleManager?.people == nil {
                state = .loading
            }
            else if let people = self?.dependencies?.peopleManager?.people, !people.isEmpty {
                state = .showData(data: (people, selectedPerson))
            }
            else {
                state = .empty
            }
            
            self?.state = state
            self?.updateChildCoordinators(withState: state)
        })
    }
    
    func updateChildCoordinators(withState state: ControllerState<([Person], Person?)>) {
        for coordinator in childCoordinators.values {
            if let people = coordinator as? PeopleNavigationCoordinator {
                updatePeople(people)
            }
            else if let person = coordinator as? PersonCoordinator {
                updatePerson(person)
            }
        }
    }
    
    func updatePeople(_ coordinator: PeopleNavigationCoordinator) {
        coordinator.state = state
    }
    
    func updatePerson(_ coordinator: PersonCoordinator) {
        switch state {
        case .empty:
            coordinator.state = .empty
            
        case .error(let error):
            coordinator.state = .error(error: error)
            
        case .loading:
            coordinator.state = .loading
            
        case .showData:
            if let person = selectedPerson {
                coordinator.state = .showData(data: person)
            }
            else {
                coordinator.state = .empty
            }
        }
    }
    
    func presentInputAlert(withTitle title: String, isInputSecured: Bool, completion: @escaping (_ success: Bool, _ text: String?) -> Void) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        controller.addTextField { [weak self] textField in
            textField.isSecureTextEntry = isInputSecured
            self?.alertTextField = textField
        }
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            completion(true, self?.alertTextField?.text)
            self?.alertTextField = nil
        }))
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            completion(false, nil)
            self?.alertTextField = nil
        }))
        
        present(controller)
    }
    
    func presentErrorMessage(_ message: String?) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(controller)
    }
}
