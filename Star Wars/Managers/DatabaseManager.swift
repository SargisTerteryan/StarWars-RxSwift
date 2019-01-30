//
//  DatabaseManager.swift
//  Star Wars
//
//  Created by Saqo on 1/19/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import CoreData
import RxCocoa
import RxSwift

enum PersonsResult {
    case success(PersonsModel)
    case failure(Error)
}

class DatabaseManager {

    private static var personsData = BehaviorRelay<[PersonsModel]>(value: [])

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Star_Wars")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    let context = DatabaseManager.persistentContainer.viewContext
    
    func saveContext () {
        let context = DatabaseManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
     static func processPersonRequest(jsonArray: [String: Any], completion: @escaping (PersonsResult) -> Void)  {
    
        persistentContainer.performBackgroundTask { (context) in

            let result = DatabaseManager.person(fromJSON: jsonArray, into: context)
        
            do {
                try context.save()
            } catch {
                print("Error saving the Core Data: \(error).")
                completion(.failure(error))
                return
            }
    
                let personIDs = result.map { return $0.objectID }
                let viewContext = self.persistentContainer.viewContext
                let viewContextPersons =  personIDs.map { return viewContext.object(with: $0) } as! PersonsModel
           
            completion(.success(viewContextPersons))
        }
    }

    static func saveToStorage(person: PersonsModel, names: [String], key: String, finished: @escaping () -> Void) -> Void {
        let context = DatabaseManager.persistentContainer.viewContext
        let storedPerson = DatabaseManager.getPersonFromStore(personName: person.name!)
        storedPerson!.setValue(names, forKey: key)
        
        do {
            try context.save()
            personsData.accept(getAllPersonFromStore()!)
            finished()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func saveToStorage(person: PersonsModel, name: String, key: String, finished: @escaping () -> Void) -> Void {
        let context = DatabaseManager.persistentContainer.viewContext
        let storedPerson = DatabaseManager.getPersonFromStore(personName: person.name!)
        storedPerson!.setValue(name, forKey: key)
        
        do {
            try context.save()
            personsData.accept(getAllPersonFromStore()!)
            finished()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
 
    static func getPersonFromStore(personName: String) -> PersonsModel? {
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PersonsModel> = PersonsModel.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(PersonsModel.name)) == %@", personName)
        fetchRequest.predicate = predicate

        var fetchedPersons: [PersonsModel]?
        context.performAndWait {
            fetchedPersons = try? fetchRequest.execute()
        }
        if let existingPerson = fetchedPersons?.first {
            return existingPerson
        }

        return nil
    }
    
    static func getAllPersonFromStore() -> [PersonsModel]? {
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PersonsModel> = PersonsModel.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(PersonsModel.name), ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
        
        var fetchedPersons: [PersonsModel]?
        context.performAndWait {
            fetchedPersons = try? fetchRequest.execute()
        }

        return fetchedPersons
    }

    static func hasStoredPersons() -> Bool {
        return DatabaseManager.getAllPersonFromStore()!.count > 0
    }
    
    public static func fetchObservableData() -> Observable<[PersonsModel]> {
        personsData.accept(getAllPersonFromStore()!)
        return personsData.asObservable()
    }
    
    private static func person(fromJSON json: [String : Any], into context: NSManagedObjectContext) -> PersonsModel? {
        guard let personWrapper = PersonWrapper(json: json) else {
            print("Don't have enough information to construct a Person")
            return nil
        }
        
        if let existingPerson = DatabaseManager.getPersonFromStore(personName: personWrapper.name!), existingPerson.edited == (personWrapper.edited! as NSDate) {
            return existingPerson
        }
        
        var person: PersonsModel!
        context.performAndWait {
            person = PersonsModel(context: context)
            person.name = personWrapper.name
            person.url = personWrapper.url
            person.birth_year = personWrapper.birth_year
            person.eye_color = personWrapper.eye_color
            person.gender = personWrapper.gender
            person.hair_color = personWrapper.hair_color
            person.skin_color = personWrapper.skin_color
            person.homeworld_url = personWrapper.homeworld_url
            person.film_urls = personWrapper.film_urls
            person.vehicles_url = personWrapper.vehicle_urls
            person.starship_urls = personWrapper.starship_urls
            person.specie_urls = personWrapper.specie_urls
            
            if let height = Double(personWrapper.heightString!) {
                person.height = height
            }
            if let mass = Double(personWrapper.massString!) {
                person.mass = mass
            }
            person.edited = personWrapper.edited! as NSDate
            
        }
        return person
    }

}
