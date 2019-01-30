//
//  PersonWrapper.swift
//  Star Wars
//
//  Created by Saqo on 1/19/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class PersonWrapper {

    private static let dateFormatterISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
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
    var features: PersonFeaturesModel?
    
    required init?(json: [String: Any]) {
        self.name = json["name"] as? String
        self.birth_year = json["birth_year"] as? String
        self.eye_color = json["eye_color"] as? String
        self.gender = json["gender"] as? String
        self.hair_color = json["hair_color"] as? String
        self.skin_color = json["skin_color"] as? String
        self.heightString = json["height"] as? String
        self.massString = json["mass"] as? String
        self.editedString = json["edited"] as? String
        self.edited = PersonWrapper.dateFormatterISO8601.date(from: editedString!)
        self.homeworld_url = json["homeworld"] as? String
        self.film_urls = json["films"] as? [String]
        self.starship_urls = json["starships"] as? [String]
        self.vehicle_urls = json["vehicles"] as? [String]
        self.specie_urls = json["species"] as? [String]
        self.url = json["url"] as? String
    }
           
    static func films(person: PersonsModel, finished: @escaping (PersonsModel) -> Void) -> Void {
        var filmNames = [String]()
        let dispatchGroup = DispatchGroup()

        for filmUrl in person.film_urls! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: filmUrl) { (result) in
                let s = result["title"]
                filmNames.append(s as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            filmNames.sort(by: <)
            DatabaseManager.saveToStorage(person: person, names: filmNames, key: "filmNames", finished: { (result) in
         
                finished(result)
            })//            DatabaseManager.savePersonFilms(person: person, filmNames: filmNames, finished: { (result) in
//                finished(result)
//            })
        }
        
    }
    
    static func starships(person: PersonsModel, finished: @escaping (PersonsModel) -> Void) -> Void {
        var starshipNames = [String]()
        let dispatchGroup = DispatchGroup()

        for starshipUrl in person.starship_urls! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: starshipUrl) { (result) in
                let s = result["name"]
                starshipNames.append(s as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            starshipNames.sort(by: < )
//            DatabaseManager.savePersonStarships(person: person, starshipNames: starshipNames, finished: { (result) in
//                finished(result)
//            })
            DatabaseManager.saveToStorage(person: person, names: starshipNames, key: "specieNames", finished: { (result) in
                
            })
        }
    }
    
    static func vehicles(person: PersonsModel, finished: @escaping (PersonsModel) -> Void) -> Void {
        var vehicleNames = [String]()
        let dispatchGroup = DispatchGroup()
        
        for vehicleUrl in person.vehicles_url! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: vehicleUrl) { (result) in
                let s = result["name"]
                vehicleNames.append(s as! String)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            vehicleNames.sort(by: < )
//            DatabaseManager.savePersonStarships(person: person, starshipNames: vehicleNames, finished: { (result) in
//                finished(result)
//            })
        }
    }
    
    private func species(person: PersonsModel, finished: @escaping (PersonsModel) -> Void) -> Void {
        var specieNames = [String]()
        let dispatchGroup = DispatchGroup()
        
        for speciesUrl in person.specie_urls! {
            dispatchGroup.enter()
            AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: speciesUrl) { (result) in
                let s = result["name"]
                specieNames.append(s as! String)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            specieNames.sort(by: < )
//            DatabaseManager.savePersonStarships(person: person, starshipNames: specieNames, finished: { (result) in
//                finished(result)
//            })
        }
        
    }
    
    private func homeworld() -> Void {
        AlamofireRequestManager.fetchPersonFeaturesFromAPI(path: homeworld_url!) { (result) in
            let s = result["name"]
//            self.features?.homeworldName = s as? String
        }
    }

}
