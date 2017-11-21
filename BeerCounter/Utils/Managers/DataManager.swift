//
//  DataManager.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class DataManager {

    enum DataType: String {
        case people
    }
    
    enum BeerOperation {
        case add
        case subtract
        case reset
    }
    
    private let defaults = UserDefaults.standard
    
    private let multiPeerManager: MultipeerManager
    
    init(multiPeerManager: MultipeerManager) {
        self.multiPeerManager = multiPeerManager
    }

    func fetchPeople(completion: (_ people: [Person], _ error: Error?) -> Void) {
        let data = getData(forKey: DataType.people.rawValue)
        if let arr = data["data"] as? [[String: Any]] {
            let people = arr.flatMap({ json -> Person? in
                guard let id = json["id"] as? String,
                    let name = json["name"] as? String,
                    let beerCount = json["beerCount"] as? Int else {
                        return nil
                }
                
                return Person(id: id, name: name, beerCount: beerCount)
            })
            
            completion(people, nil)
        }
        else {
            completion([], nil)
        }
    }

    func addPerson(_ person: Person, completion: (_ error: Error?) -> Void) {
        let person: [String: Any] = ["id": person.id, "name": person.name, "beerCount": person.beerCount]
        var stored = getData(forKey: DataType.people.rawValue)
        if var people = stored["data"] as? [[String: Any]] {
            people.append(person)
            stored["data"] = people
        }
        else {
            stored["data"] = [person]
        }
        setData(stored, forKey: DataType.people.rawValue)
        completion(nil)
    }
    
    func deletePerson(_ person: Person, completion: (_ error: Error?) -> Void) {
        var stored = getData(forKey: DataType.people.rawValue)
        if var people = stored["data"] as? [[String: Any]],
            let index = people.index(where: { ($0["id"] as? String) == person.id }) {
            
            people.remove(at: index)
            stored["data"] = people
        }
        setData(stored, forKey: DataType.people.rawValue)
        completion(nil)
    }

    func addBeer(toPerson person: Person, completion: (_ error: Error?) -> Void) {
        updateBeerCount(personId: person.id, operation: .add)
        completion(nil)
    }
    
    func subtractBeer(forPerson person: Person, completion: (_ error: Error?) -> Void) {
        updateBeerCount(personId: person.id, operation: .subtract)
        completion(nil)
    }
    
    func resetBeerCount(forPerson person: Person, completion: (_ error: Error?) -> Void) {
        updateBeerCount(personId: person.id, operation: .reset)
        completion(nil)
    }

    func updateDatabase(withData data: Data) {
        let stored = getData(forKey: DataType.people.rawValue)
        let timestamp = stored["_ts"] as? TimeInterval ?? 0
        if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any], let ts = dict["_ts"] as? TimeInterval, timestamp < ts {
            setData(dict, forKey: DataType.people.rawValue, distributeToPeers: false)
        }
    }

    func distributeDatabase(toPeer peer: MCPeerID) {
        distributeData(toPeer: peer)
    }
}

private extension DataManager {
    
    func getData(forKey key: String) -> [String: Any] {
        return defaults.object(forKey: key) as? [String: Any] ?? [:]
    }
    
    func setData(_ data: [String: Any], forKey key: String, distributeToPeers: Bool = true) {
        var timestampedData = data
        timestampedData["_ts"] = Date().timeIntervalSince1970
        defaults.set(timestampedData, forKey: key)
        defaults.synchronize()
        if distributeToPeers {
            distributeData()
        }
    }

    func updateBeerCount(personId: String, operation: BeerOperation) {
        var stored = getData(forKey: DataType.people.rawValue)
        if var people = stored["data"] as? [[String: Any]],
            let index = people.index(where: { ($0["id"] as? String) == personId }) {
            
            var person = people.remove(at: index)
            let count = person["beerCount"] as? Int ?? 0
            switch operation {
            case .add:
                person["beerCount"] = count + 1
            case .subtract:
                person["beerCount"] = count - 1
            case .reset:
                person["beerCount"] = 0
            }
            people.insert(person, at: index)
            stored["data"] = people
        }
        setData(stored, forKey: DataType.people.rawValue)
    }
    
    func distributeData(toPeer peer: MCPeerID? = nil) {
        let people = getData(forKey: DataType.people.rawValue)
        let data = NSKeyedArchiver.archivedData(withRootObject: people)
        multiPeerManager.sendData(data: data, toPeer: peer)
    }
}
