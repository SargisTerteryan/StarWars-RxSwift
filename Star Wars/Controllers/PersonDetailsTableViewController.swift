//
//  PersonDetailsTableViewController.swift
//  Star Wars
//
//  Created by Saqo on 1/19/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum Sections: Int {
    case Details
    case Films
    case Species
    case Starships
    case Vehicles
}

enum Details: Int {
    case Name
    case BirthYear
    case Gender
    case Homeworld
    case Height
    case Mass
    case EyeColor
    case HairColor
    case SkinColor
}

class PersonDetailsTableViewController: UITableViewController {

    struct Constants {
        // Cell Identifiers
        static let BasicCellIdentifier = "basicCell"
        static let DetailCellIdentifier = "detailCell"
        // Section titles
        static let DetailsTitle = "Details"
        static let FilmsTitle = "Films"
        static let SpeciesTitle = "Species"
        static let StarshipsTitle = "Starships"
        static let VehiclesTitle = "Vehicles"
        // Cell default texts
        static let NameLabelText = "Name:"
        static let BirthYearLabelText = "Birth Year:"
        static let GenderLabelText = "Gender:"
        static let HomeworldLabelText = "Homeworld:"
        static let HeightLabelText = "Height:"
        static let MassLabelText = "Mass:"
        static let EyeColorLabelText = "Eye Color:"
        static let HairColorLabelText = "Hair Color:"
        static let SkinColorLabelText = "Skin Color:"
        static let Unknown = "Unknown"
        // Section constants
        static let DetailsRowCount = 9
        static let SectionCount = 5
    }
    
    private var personModel: PersonsModel!

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.tableFooterView = UIView()
    }
    
    func setPerson(person: PersonsModel) {
        self.personModel = DatabaseManager.getPersonFromStore(personName: person.name!)

        self.personModel.getFeaturesIfNeeded {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.green
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case Sections.Details.rawValue:
                return Constants.DetailsTitle
            case Sections.Films.rawValue:
                return personModel.filmsCount() > 0 ? Constants.FilmsTitle : ""
            case Sections.Species.rawValue:
                return personModel.speciesCount() > 0 ? Constants.SpeciesTitle : ""
            case Sections.Starships.rawValue:
                return personModel.starshipsCount() > 0 ? Constants.StarshipsTitle : ""
            case Sections.Vehicles.rawValue:
                return personModel.vehiclesCount() > 0 ? Constants.VehiclesTitle : ""
            default: return ""
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.SectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case Sections.Details.rawValue: return Constants.DetailsRowCount
            case Sections.Films.rawValue: return personModel.filmsCount()
            case Sections.Species.rawValue: return personModel.speciesCount()
            case Sections.Starships.rawValue: return personModel.starshipsCount()
            case Sections.Vehicles.rawValue: return personModel.vehiclesCount()
            default: return 0
        }
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        
        switch indexPath.section {
            case Sections.Details.rawValue:
                cell = buildCellForDetails(withRowIndex: indexPath.row)
            case Sections.Films.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.BasicCellIdentifier, for: indexPath)
                cell.textLabel?.text = personModel.filmNames?[indexPath.row]
            case Sections.Species.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.BasicCellIdentifier, for: indexPath)
                cell.textLabel?.text = personModel.specieNames?[indexPath.row]
            case Sections.Starships.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.BasicCellIdentifier, for: indexPath)
                cell.textLabel?.text = personModel.starshipNames?[indexPath.row]
            case Sections.Vehicles.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.BasicCellIdentifier, for: indexPath)
                cell.textLabel?.text = personModel.vehicleNames?[indexPath.row]
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.BasicCellIdentifier, for: indexPath)
                cell.textLabel?.text = ""
        }
        return cell

    }
    
    private func buildCellForDetails(withRowIndex index: Int) -> UITableViewCell {
        
        let reuseIdentifier = Constants.DetailCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .value2, reuseIdentifier: reuseIdentifier)

        switch index {
        case Details.Name.rawValue:
            cell.textLabel?.text = Constants.NameLabelText
            if let birthYear = personModel.name {
                cell.detailTextLabel?.text = birthYear
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.BirthYear.rawValue:
            cell.textLabel?.text = Constants.BirthYearLabelText
            if let birthYear = personModel.birth_year {
                cell.detailTextLabel?.text = birthYear
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.Gender.rawValue:
            cell.textLabel?.text = Constants.GenderLabelText
            if let gender = personModel.gender {
                cell.detailTextLabel?.text = gender
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.Homeworld.rawValue:
            cell.textLabel?.text = Constants.HomeworldLabelText
            if let homeworld = personModel.homeworldName {
                cell.detailTextLabel?.text = homeworld
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.Height.rawValue:
            cell.textLabel?.text = Constants.HeightLabelText
            if personModel.height != 0 {
                cell.detailTextLabel?.text = "\(String(describing: personModel.height)) cm."
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.Mass.rawValue:
            cell.textLabel?.text = Constants.MassLabelText
            if personModel?.mass != 0 {
                cell.detailTextLabel?.text = "\(String(describing: personModel.mass)) kg."
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.EyeColor.rawValue:
            cell.textLabel?.text = Constants.EyeColorLabelText
            if let eyeColor = personModel.eye_color {
                cell.detailTextLabel?.text = eyeColor
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.HairColor.rawValue:
            cell.textLabel?.text = Constants.HairColorLabelText
            if let hairColor = personModel.hair_color {
                cell.detailTextLabel?.text = hairColor
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        case Details.SkinColor.rawValue:
            cell.textLabel?.text = Constants.SkinColorLabelText
            if let skinColor = personModel.skin_color {
                cell.detailTextLabel?.text = skinColor
            } else {
                cell.detailTextLabel?.text = Constants.Unknown
            }
        default: break
        }
        return cell
        
    }

}
