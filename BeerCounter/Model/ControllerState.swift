//
//  ControllerState.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import Foundation

enum ControllerState<Data> {
    case loading
    case showData(data: Data)
    case error(error: Error?)
    case empty
}
