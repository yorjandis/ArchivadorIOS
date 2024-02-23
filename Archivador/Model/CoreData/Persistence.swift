//
//  Persistence.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 22/2/24.
//

import CoreData

struct PersistenceController {
    
    private let container: NSPersistentCloudKitContainer
    
    static let shared = PersistenceController() //Singleton

    //Acceso al contexto de objeto administrado
    var context : NSManagedObjectContext {
        return container.viewContext
    }
   
    
   func save(){
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                context.rollback()
                print(error.localizedDescription)
            }
        }
    }

    init() {
        container = NSPersistentCloudKitContainer(name: "Archivador")
       
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                print(error.localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
