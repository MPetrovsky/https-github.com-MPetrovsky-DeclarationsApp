//
//  CoreDataManager.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 02.09.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerDelegateForViewCotroller: class {
    func updateInStorage()
    
}
protocol CoreDataManagerDelegateForFavourite: class {
    func sendFavouriteData(data: [PersonsInfoStored])
}

class CoreDataManager {
    static let sharedDataManager = CoreDataManager()
    private init() { }
    weak var coreDataManagerDelegateForVC: CoreDataManagerDelegateForViewCotroller?
    weak var coreDataManagerDelegateForFVC: CoreDataManagerDelegateForFavourite?
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        
    }
    
    func updateWhenUnfavourite(id: String, controller: UIViewController) {
        let context = persistentContainer.viewContext
        let request :NSFetchRequest<PersonsInfoStored> = PersonsInfoStored.fetchRequest()
        request.predicate = NSPredicate(format: "id= %@", id)
        do {
            let resultsForExistRequest  = try context.fetch(request)
            if ((resultsForExistRequest.count) > 0) {
                print ("Exist")
                
                
                for object in resultsForExistRequest {
                    context.delete(object)
                    
                }
                CoreDataManager.sharedDataManager.saveContext()
                AlertManager.sharedAlertManager.alertOk(message: "", title: "Видалено", controller: controller)
             
            }
            else {
                print("Not exist")
                
                coreDataManagerDelegateForVC?.updateInStorage()
            }
        } catch {
            print ("Error fetching data \(error)")
        }
    }
    
    func deleteFromCoreData(targetArray: [PersonsInfoStored], targetIndex: Int ) {
        let context = persistentContainer.viewContext
        context.delete(targetArray[targetIndex])
        CoreDataManager.sharedDataManager.saveContext()
        
    }
    func loadCoreData(){
        let context = persistentContainer.viewContext
            let request :NSFetchRequest<PersonsInfoStored> = PersonsInfoStored.fetchRequest()
            do {
                let targetArray: [PersonsInfoStored]
                targetArray = (try context.fetch(request))
                self.coreDataManagerDelegateForFVC?.sendFavouriteData(data: targetArray)
            } catch {
                print ("Error fetching data \(error)")
                
            }
            
        }
        
    
}
