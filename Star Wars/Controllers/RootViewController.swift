//
//  ViewController.swift
//  Star Wars
//
//  Created by Saqo on 1/18/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

enum Segment: Int {
    case First
    case Second
}

class RootViewController: UIViewController {

    struct Constants {
        static let SearchTableViewControllerVariable = "SearchViewController"
        static let HistoryTableViewControllerVariable = "HistoryViewController"
        static let FirstSegmentItemTitle = "API Search"
        static let SecondSegmentItemTitle = "History"
    }
 
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private lazy var searchTableViewController: SearchViewController = {
        let tableViewController = Helper.instantiateFromStoryboard(identifier: Constants.SearchTableViewControllerVariable) as! SearchViewController

        return tableViewController
    }()
    
    private lazy var historyViewController: HistoryViewController = {
        let viewController = Helper.instantiateFromStoryboard(identifier: Constants.HistoryTableViewControllerVariable) as! HistoryViewController

        return viewController
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        updateView()
    }
    
    // MARK: - View Methods
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: historyViewController)
            add(asChildViewController: searchTableViewController)
        } else {
            remove(asChildViewController: searchTableViewController)
            add(asChildViewController: historyViewController)
        }
    }
    
    private func setupSegmentedControl() {
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(withTitle: Constants.FirstSegmentItemTitle, at: Segment.First.rawValue, animated: false)
        segmentControl.insertSegment(withTitle: Constants.SecondSegmentItemTitle, at: Segment.Second.rawValue, animated: false)
        segmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        segmentControl.selectedSegmentIndex = DatabaseManager.hasStoredPersons() ? Segment.Second.rawValue : Segment.First.rawValue
    }
    
    // MARK: - Actions
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    // MARK: - Helper Methods

    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }


}
