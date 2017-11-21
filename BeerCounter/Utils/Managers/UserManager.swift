//
//  UserManager.swift
//  BeerCounter
//
//  Created by Jan on 17/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import Foundation

class UserManager {
    
    enum UserError: Error, LocalizedError {
        case wrongPassword
        case adminAlreadyLoggedIn
        
        var errorDescription: String? {
            switch self {
            case .adminAlreadyLoggedIn:
                return "Admin user is already logged in"
                
            case .wrongPassword:
                return "Wrong password"
            }
        }
    }
    
    private(set) var isAdmin: Bool = false
    
    func login(withPassword password: String?, completion: (_ error: Error?) -> Void) {
        if isAdmin {
            completion(UserError.adminAlreadyLoggedIn)
        }
        else if password == "1234" {
            isAdmin = true
            completion(nil)
        }
        else {
            completion(UserError.wrongPassword)
        }
    }
    
    func logout(completion: (_ error: Error?) -> Void) {
        isAdmin = false
        completion(nil)
    }
}
