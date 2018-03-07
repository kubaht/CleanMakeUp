//
//  EntityManager.swift
//  CleanMakeUp
//
//  Created by Jakub Hutny on 12.10.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation

public class EntityManager {
    
    public static func disableAllEntities() {
        let setups = SetupService.getAll()
        if !setups.isEmpty {
            for setup in setups {
                setup.isSetUp = false
                SetupService.update(updatedSetup: setup)
            }
        }
    }
}
