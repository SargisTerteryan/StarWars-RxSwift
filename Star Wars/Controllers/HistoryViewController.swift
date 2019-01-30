//
//  HistoryViewController.swift
//  Star Wars
//
//  Created by Saqo on 1/24/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class HistoryViewController: UIViewController {
    
    struct Constants {
        static let PersonDetailsTableViewControllerVariable = "PersonDetailsTableViewController"
        static let HistoryCellIdentifier = "historyCell"
    }

    @IBOutlet weak var historyTableView: UITableView!

    private let disposeBag = DisposeBag()
    private var personViewModel = PersonViewModel()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.tableFooterView = UIView()
    
        populatePersonListTableView()
        onTableViewCellClick()
    }
    
    // MARK: - Table View Setup
    
    private func populatePersonListTableView() {
        let observablePersons = personViewModel.getAllPersons().asObservable()
        
        observablePersons.bind(to: historyTableView.rx.items(cellIdentifier: Constants.HistoryCellIdentifier, cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .disposed(by: disposeBag)
    }
    
    private func onTableViewCellClick() {
        Observable
            .zip(historyTableView.rx.itemSelected, historyTableView.rx.modelSelected(PersonsModel.self))
            .bind { [unowned self] indexPath, model in
                self.historyTableView.deselectRow(at: indexPath, animated: true)
                self.navigateToPersonDetailsViewController(model: model)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Helper
    
    private func navigateToPersonDetailsViewController(model: PersonsModel) {
        let destination = Helper.instantiateFromStoryboard(identifier: Constants.PersonDetailsTableViewControllerVariable) as! PersonDetailsTableViewController
        destination.setPerson(person: model)
        
        self.navigationController?.pushViewController(destination, animated: true)
    }

}
