//
//  Helper.swift
//  Star Wars
//
//  Created by Saqo on 1/20/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class Helper {
    
    static let StoryboardName = "Main"
    static let DataFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    
    static let dateFormatterISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = Helper.DataFormat
        return formatter
    }()
    
    static func instantiateFromStoryboard(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: Helper.StoryboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    static func showErrorAllert(controller: UIViewController, errorMessage: String) -> Void {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }

}
