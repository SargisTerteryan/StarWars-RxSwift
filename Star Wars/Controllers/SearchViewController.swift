//
//  SearchViewController.swift
//  Star Wars
//
//  Created by Saqo on 1/24/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {

    struct Constants {
        static let PersonDetailsTableViewControllerVariable = "PersonDetailsTableViewController"
        static let SearchBarPlaceholder = "Search Star Wars from API"
        static let PersonCellIdentifier = "personCell"
        static let personNameKey = "name"
        static let spinnerSize = 20
    }
    
    @IBOutlet weak var searchResultTableView: UITableView!

    private var resultSearchController = UISearchController()
    private let disposeBag = DisposeBag()
    private var personsData = [[String: Any]]()

    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultTableView.tableFooterView = UIView()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = Constants.SearchBarPlaceholder
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            searchResultTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    
        handleSearchControllerResult()
        onTableViewCellClick()
    }
    
    // MARK: - Actions

    private func handleSearchControllerResult() {
        resultSearchController
            .searchBar
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .flatMapLatest { text in self.searchRequest(search: text) }
            .bind(to: self.searchResultTableView.rx.items(cellIdentifier: Constants.PersonCellIdentifier, cellType: UITableViewCell.self)) {  row, persons, cell in
                cell.textLabel?.text = persons[Constants.personNameKey] as? String
            }
            .disposed(by: disposeBag)
    }

    private func onTableViewCellClick() {
        searchResultTableView.rx.itemSelected
            .map { indexPath in
                self.searchResultTableView.deselectRow(at: indexPath, animated: true)

                return (self.personsData[indexPath.row])
            }.subscribe({ result in
                self.handleCellTap(json: result)
        })
        .disposed(by: disposeBag)
    }

    private func handleCellTap(json: Event<[String : Any]>) {
        resultSearchController.isActive = false
    
        let destination = Helper.instantiateFromStoryboard(identifier: Constants.PersonDetailsTableViewControllerVariable) as! PersonDetailsTableViewController
        
        DatabaseManager.processPersonRequest(jsonArray: json.element!) { (result) in
            switch result {
            case .success(let data):
                destination.setPerson(person: data)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(destination, animated: true)
                    
                }
            case .failure(let error):
                let errorMessage = "\(error.localizedDescription)"
                Helper.showErrorAllert(controller: self, errorMessage: errorMessage)
            }
        }
    }
    
    private func searchRequest(search: String) -> Observable<[[String: Any]]> {
        setLoadingOnScreen()
    
        if search.isEmpty {
            self.removeLoading()
            return .just([])
        }

        return Observable.create { observer in
            AlamofireRequestManager.fetchMatchingPersonsFromAPI(path: search, completion: { (result) in
                self.personsData = result.value!
                observer.onNext(self.personsData)
                observer.onCompleted()
                self.removeLoading()
            })
            return Disposables.create()
        }
    }
    
    // MARK: - View Methods

    private func setLoadingOnScreen() {
        loadingView.center = searchResultTableView.center
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: Constants.spinnerSize, height: Constants.spinnerSize)
        spinner.startAnimating()
        loadingView.addSubview(spinner)
        searchResultTableView.addSubview(loadingView)
    }

    private func removeLoading() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
}
