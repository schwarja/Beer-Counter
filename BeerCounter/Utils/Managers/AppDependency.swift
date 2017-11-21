//
//  AppDependency.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 10.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

struct AppDependency {
	var dataManager: DataManager?
	var peopleManager: PeopleManager?
    var userManager: UserManager?
    var multipeerManager: MultipeerManager?

	init(dataManager: DataManager? = nil,
	     peopleManager: PeopleManager? = nil,
         userManager: UserManager? = nil,
         multipeerManager: MultipeerManager? = nil)
	{
		self.dataManager = dataManager
		self.peopleManager = peopleManager
        self.userManager = userManager
        self.multipeerManager = multipeerManager
	}
}
