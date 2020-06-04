//
//  CoreDataManager.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/28/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NealAlertModel")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func fetchedResultsController(with sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "contactname", ascending: true)]) -> NSFetchedResultsController<Contacts> {
        let fetchRequest: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        return NSFetchedResultsController<Contacts>(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var entityName: String {
        return "Contacts"
    }
    
    func addContacts(_ contactName: String, _ contactNumber: String) {
        let contact = NSEntityDescription.insertNewObject(forEntityName: entityName, into: viewContext)
        
        contact.setValue(contactName, forKey: "contactname")
        contact.setValue(contactNumber, forKey: "contactnumber")
        
        save()
    }
    
    func updateContact(contact: Contacts) {
        save()
    }
    
    func remove(_ contact: Contacts) {
        let fetchRequest: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             argumentArray: ["contactname", contact.unwrapped(.contactname),
                                                             "contactnumber", contact.unwrapped(.contactnumber)])
        do {
            guard let contacts = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                return
            }
            viewContext.delete(contacts)
            save()
        } catch let error {
            print("Unable to fetch contact \(error.localizedDescription)")        }
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch let error {
            print("Failed to save. \(error.localizedDescription)")
        }
    }
}

extension Contacts {
    enum Attribute {
        case contactname
        case contactnumber
    }
    
    func unwrapped (_ attribute: Attribute) -> String {
        switch attribute {
            case .contactname:
                return contactname ?? ""
            case .contactnumber:
            return contactnumber ?? ""
        }
    }
}
