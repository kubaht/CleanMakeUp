//
//  Setup+CoreDataProperties.swift
//  CleanMakeUp
//
//  Created by Jakub Hutny on 29.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation
import CoreData


extension Setup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setup> {
        return NSFetchRequest<Setup>(entityName: "Setup");
    }

    @NSManaged public var isSetUp: Bool
    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16

}
