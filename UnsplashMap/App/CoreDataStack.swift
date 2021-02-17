//
//  CoreDataStack.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UnsplashMap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }


    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData: saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
