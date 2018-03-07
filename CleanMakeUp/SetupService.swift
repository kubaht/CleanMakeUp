//
//  SetupService.swift
//  CleanYourMakeUp
//
//  Created by Jakub Hutny on 28.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class SetupService {
    
    // PRIVATE FIELDS
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // PUBLIC METHODS
    
    public static func saveChanges(){
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    public static func create(hour: Int, minute: Int) -> Setup {
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: Setup.entityName, into: SetupService.context) as! Setup
        
        newItem.hour = Int16(hour)
        newItem.minute = Int16(minute)
        newItem.isSetUp = true
        
        return newItem
    }
    
    // Predicates examples:
    // - NSPredicate(format: "name == %@", "something")
    // - NSPredicate(format: "name contains %@", "something")
    public static func get(withPredicate queryPredicate: NSPredicate) -> [Setup] {
        let fetchRequest = NSFetchRequest<Setup>(entityName: Setup.entityName)
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try SetupService.context.fetch(fetchRequest)
            return response
            
        } catch let error as NSError {
            print(error)
            return [Setup]()
        }
    }
    
    public static func getAll() -> [Setup]{
        return SetupService.get(withPredicate: NSPredicate(value:true))
    }
    
    public static func getId(withPredicate queryPredicate: NSPredicate) -> NSManagedObjectID {
        return (SetupService.get(withPredicate: queryPredicate).first?.objectID)!
    }
    
    public static func getById(id: NSManagedObjectID) -> Setup? {
        return SetupService.context.object(with: id) as? Setup
    }
    
    public static func update(updatedSetup: Setup) -> Void {
        if let setup = SetupService.getById(id: updatedSetup.objectID){
            setup.hour = updatedSetup.hour
            setup.minute = updatedSetup.minute
            setup.isSetUp = updatedSetup.isSetUp
        }
    }
    
    public static func delete(id: NSManagedObjectID) -> Void {
        if let typeToDelete = SetupService.getById(id: id){
            SetupService.context.delete(typeToDelete)
        }
    }
}
