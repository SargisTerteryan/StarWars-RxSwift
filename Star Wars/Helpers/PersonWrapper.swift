//
//  PersonWrapper.swift
//  Star Wars
//
//  Created by Saqo on 1/19/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class PersonWrapper {

    struct KeyConstants {
        static let FilmNames = "filmNames"
        static let StarshipNames = "starshipNames"
        static let VehicleNames = "vehicleNames"
        static let SpecieNames = "specieNames"
        static let HomeworldName = "homeworldName"
    }

    struct PersonFields {
        static let Name = "name"
        static let BirthYear = "birth_year"
        static let EyeColor = "eye_color"
        static let Gender = "gender"
        static let HairColor = "hair_color"
        static let SkinColor = "skin_color"
        static let Height = "height"
        static let Mass = "mass"
        static let Edited = "edited"
        static let Homeworld = "homeworld"
        static let Films = "films"
        static let Starships = "starships"
        static let Vehicles = "vehicles"
        static let Species = "species"
        static let Url = "url"
        static let Title = "title"
    }

    var name: String?
    var heightString: String?
    var massString: String?
    var hair_color: String?
    var skin_color: String?
    var eye_color: String?
    var birth_year: String?
    var editedString: String?
    var gender: String?
    var url: String?
    var homeworld_url: String?
    var film_urls: [String]?
    var specie_urls: [String]?
    var starship_urls: [String]?
    var vehicle_urls: [String]?
    var edited: Date?
    
    required init?(json: [String: Any]) {
        self.name = json[PersonFields.Name] as? String
        self.birth_year = json[PersonFields.BirthYear] as? String
        self.eye_color = json[PersonFields.EyeColor] as? String
        self.gender = json[PersonFields.Gender] as? String
        self.hair_color = json[PersonFields.HairColor] as? String
        self.skin_color = json[PersonFields.SkinColor] as? String
        self.heightString = json[PersonFields.Height] as? String
        self.massString = json[PersonFields.Mass] as? String
        self.editedString = json[PersonFields.Edited] as? String
        self.edited = Helper.dateFormatterISO8601.date(from: editedString!)
        self.homeworld_url = json[PersonFields.Homeworld] as? String
        self.film_urls = json[PersonFields.Films] as? [String]
        self.starship_urls = json[PersonFields.Starships] as? [String]
        self.vehicle_urls = json[PersonFields.Vehicles] as? [String]
        self.specie_urls = json[PersonFields.Species] as? [String]
        self.url = json[PersonFields.Url] as? String
    }
           
    static func films(person: PersonsModel, finished: @escaping () -> Void) -> Void {
        var filmNames = [String]()
        let dispatchGroup = DispatchGroup()

        for filmUrl in person.film_urls! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: filmUrl) { (result) in
                let filmTitle = result[PersonFields.Title]
                filmNames.append(filmTitle as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            filmNames.sort(by: <)
            DatabaseManager.saveToStorage(person: person, names: filmNames, key: KeyConstants.FilmNames, finished: { () in
                    finished()
            })
        }
        
    }
    
    static func starships(person: PersonsModel, finished: @escaping () -> Void) -> Void {
        var starshipNames = [String]()
        let dispatchGroup = DispatchGroup()

        for starshipUrl in person.starship_urls! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: starshipUrl) { (result) in
                let starshipName = result[PersonFields.Name]
                starshipNames.append(starshipName as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            starshipNames.sort(by: < )
            DatabaseManager.saveToStorage(person: person, names: starshipNames, key: KeyConstants.StarshipNames, finished: { () in
                    finished()
            })
        }
    }
    
    static func vehicles(person: PersonsModel, finished: @escaping () -> Void) -> Void {
        var vehicleNames = [String]()
        let dispatchGroup = DispatchGroup()
        
        for vehicleUrl in person.vehicles_url! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: vehicleUrl) { (result) in
                let vehicleName = result[PersonFields.Name]
                vehicleNames.append(vehicleName as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            vehicleNames.sort(by: < )
            DatabaseManager.saveToStorage(person: person, names: vehicleNames, key: KeyConstants.VehicleNames, finished: { () in
                    finished()
            })
        }
    }
    
    static func species(person: PersonsModel, finished: @escaping () -> Void) -> Void {
        var specieNames = [String]()
        let dispatchGroup = DispatchGroup()
        
        for speciesUrl in person.specie_urls! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: speciesUrl) { (result) in
                let specieName = result[PersonFields.Name]
                specieNames.append(specieName as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            specieNames.sort(by: < )
            DatabaseManager.saveToStorage(person: person, names: specieNames, key: KeyConstants.SpecieNames, finished: { () in
                    finished()
            })
        }
        
    }

    static func homeworld(person: PersonsModel, finished: @escaping () -> Void) -> Void {
        AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: person.homeworld_url!) { (result) in
            let homeworldName = result[PersonFields.Name] as! String
            DatabaseManager.saveToStorage(person: person, name: homeworldName, key: KeyConstants.HomeworldName, finished: { () in
                    finished()
            })
        }
    }

}
