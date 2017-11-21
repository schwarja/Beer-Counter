//
//  PeopleContentViewController.swift
//  BeerCounter
//
//  Created by Jan on 17/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PeopleContentViewController: UITableViewController {
    
    private var privatePeople: [Person] = []
    
    var people: [Person] {
        get {
            return privatePeople
        }
        set {
            if isViewLoaded {
                privatePeople = newValue
                tableView.reloadData()
            }
        }
    }
    var canDeletePeople = false {
        didSet {
            if isViewLoaded && canDeletePeople != oldValue {
                tableView.reloadData()
            }
        }
    }
    var selectedPerson: Person? {
        didSet {
            if isViewLoaded {
                setupUI()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privatePeople.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell

        cell.configure(withPerson: privatePeople[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canDeletePeople
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = privatePeople.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.deletePerson(person: person, sender: self)
            })
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPerson(person: privatePeople[indexPath.row], sender: self)
    }
}

private extension PeopleContentViewController {
    
    func setupUI() {
        if let person = selectedPerson, let index = people.index(of: person) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
