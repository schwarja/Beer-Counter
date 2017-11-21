//
//  PeopleManager.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import Foundation

class PeopleManager {
    
    let dataManager: DataManager
    
    private(set) var people: [Person] = []
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func fetch(completion: (_ error: Error?) -> Void) {
        dataManager.fetchPeople { [weak self] (people, error) in
            self?.people = people
            completion(error)
        }
    }
    
    func addPerson(name: String, completion: (_ error: Error?) -> Void) {
        let person = Person(id: UUID().uuidString, name: name, beerCount: 0)
        dataManager.addPerson(person, completion: completion)
    }
    
    func deletePerson(_ person: Person, completion: (_ error: Error?) -> Void) {
        dataManager.deletePerson(person, completion: completion)
    }

    func addBeer(toPerson person: Person, completion: (_ error: Error?) -> Void) {
        dataManager.addBeer(toPerson: person, completion: completion)
    }
    
    func subtractBeer(forPerson person: Person, completion: (_ error: Error?) -> Void) {
        dataManager.subtractBeer(forPerson: person, completion: completion)
    }
    
    func resetBeerCount(forPerson person: Person, completion: (_ error: Error?) -> Void) {
        dataManager.resetBeerCount(forPerson: person, completion: completion)
    }
}
