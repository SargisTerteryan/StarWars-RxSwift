//
//  PersonsModel.swift
//  Star Wars
//
//  Created by Saqo on 1/19/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import CoreData

@objc(PersonsModel)
class PersonsModel: NSManagedObject {
    private var downloadFilmsIsComplate: Bool = false
    private var downloadStarshipsIsComplate: Bool = false
    private var downloadVehiclesIsComplate: Bool = false
    private var downloadSpeciesIsComplate: Bool = false
    private var downloadHomeworldIsComplate: Bool = false
}

extension PersonsModel {
    
    public class func fetchRequest() -> NSFetchRequest<PersonsModel> {
        return NSFetchRequest<PersonsModel>(entityName: "PersonsModel")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var height: Double
    @NSManaged public var mass: Double
    @NSManaged public var hair_color: String?
    @NSManaged public var skin_color: String?
    @NSManaged public var eye_color: String?
    @NSManaged public var birth_year: String?
    @NSManaged public var edited: NSDate?
    @NSManaged public var gender: String?
    @NSManaged public var url: String?
    @NSManaged public var homeworld_url: String?
    @NSManaged public var film_urls: [String]?
    @NSManaged public var specie_urls: [String]?
    @NSManaged public var starship_urls: [String]?
    @NSManaged public var vehicles_url: [String]?
    
    @NSManaged public var filmNames: [String]?
    @NSManaged public var homeworldName: String?
    @NSManaged public var specieNames: [String]?
    @NSManaged public var starshipNames: [String]?
    @NSManaged public var vehicleNames: [String]?
    
    public func filmsCount() -> Int {
        return filmNames?.count ?? 0
    }
    
    public func speciesCount() -> Int {
        return specieNames?.count ?? 0
    }
    
    public func starshipsCount() -> Int {
        return starshipNames?.count ?? 0
    }
    
    public func vehiclesCount() -> Int {
        return vehicleNames?.count ?? 0
    }
    
    public func getFeaturers(finished: @escaping () -> Void) -> Void {
        if filmNames == nil {
            PersonWrapper.films(person: self) {() in
                self.downloadFilmsIsComplate = true
                if self.checkResults() {
                    finished()
                }
            }
        }
        
        if starshipNames == nil {
            PersonWrapper.starships(person: self) { () in
                self.downloadStarshipsIsComplate = true
                if self.checkResults() {
                    finished()
                }
                
            }
        }
        
        if vehicleNames == nil {
            PersonWrapper.vehicles(person: self) { () in
                self.downloadVehiclesIsComplate = true
                if self.checkResults() {
                    finished()
                }
            }
        }
        
        if specieNames == nil {
            PersonWrapper.species(person: self) { () in
                self.downloadSpeciesIsComplate = true
                if self.checkResults() {
                    finished()
                }
            }
            
        }
    
        if homeworldName == nil {
            PersonWrapper.homeworld(person: self) { () in
                self.downloadHomeworldIsComplate = true
                if self.checkResults() {
                    finished()
                }
            }
        }
        
    }

    private func checkResults() -> Bool {
        return downloadFilmsIsComplate && downloadStarshipsIsComplate && downloadHomeworldIsComplate && downloadSpeciesIsComplate && downloadVehiclesIsComplate
    }
}
