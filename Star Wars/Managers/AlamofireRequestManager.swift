//
//  AlamofireRequestManager.swift
//  Star Wars
//
//  Created by Saqo on 1/19/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireRequestManager {

    private static let apiUrl = "https://swapi.co/api/people"
    private static let parameterKey = "search"

    class func fetchMatchingPersonsFromAPI(path: String, completion: @escaping (Result<[[String: Any]]>) -> Void) {
 
        Alamofire.request(apiUrl,
                          method: .get,
                          parameters: [parameterKey: path])
        .validate()
        .responseJSON { response in
            guard response.result.isSuccess else {
                print("Error: \(String(describing: response.result.error?.localizedDescription))")
                completion(.failure(response.result.error!))
                return
            }

            guard let value = response.result.value as? [String: Any],
                let results = value["results"] as? [[String: Any]] else {
                    print("Can not feth data.")
                    return
            }

            completion(.success(results))

        }
    }
    
    class func fetchPersonFeaturesFromAPI(path: String, completion: @escaping ([String: Any]) -> Void) {

        Alamofire.request(path,
                          method: .get)
        .validate()
        .responseJSON { response in
            guard response.result.isSuccess else {
                print("Error: \(String(describing: response.result.error?.localizedDescription))")
                return
            }
    
            guard let value = response.result.value as? [String: Any] else {
                    print("Can not feth data.")
                    return
            }
            completion(value)
        }
    }

}
