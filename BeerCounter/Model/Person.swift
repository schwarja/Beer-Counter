//
//  Person.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import Foundation

class Person: NSObject {
    
    let id: String
    let name: String
    let beerCount: Int
    
    init(id: String, name: String, beerCount: Int) {
        self.id = id
        self.name = name
        self.beerCount = beerCount
    }
}
