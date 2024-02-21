//
//  CoreDataManager.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 20/02/2024.
//

import Foundation

import CoreData

/// A singleton class responsible for managing the Core Data stack, including the managed object context and persistence store.
final class CoreDataManager {
    
    //MARK: - Properties
    let modelName = "TechincalAssmeent"
    static let shared = CoreDataManager()
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = self.container.viewContext
        return managedObjectContext
    }()
    
    let container: NSPersistentContainer
    
    
    //MARK: - init
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: modelName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
    //MARK: - Helpers
    func clearAllData() {
        let context = container.viewContext
        
        do {
            let entities = container.persistentStoreCoordinator.managedObjectModel.entities
            
            for entity in entities {
                guard let entityName = entity.name else { continue }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                
                if let objects = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    for object in objects {
                        context.delete(object)
                    }
                }
            }
            
            try context.save()
        } catch let error {
            print("ERROR DELETING ALL DATA: \(error)")
        }
    }
    
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                container.viewContext.mergePolicy = NSOverwriteMergePolicy
                try container.viewContext.save()
            } catch {
                let saveError = error as NSError
                debugPrint("Unable to Save Changes of Managed Object Context")
                debugPrint("\(saveError), \(saveError.localizedDescription)")
            }
        }
    }
    
    
}


