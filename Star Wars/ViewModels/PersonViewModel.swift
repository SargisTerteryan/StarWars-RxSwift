//
//  PersonViewModel.swift
//  Star Wars
//
//  Created by Saqo on 1/24/19.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct PersonViewModel {
    
    private var persons =  BehaviorRelay<[PersonsModel]>(value: [])
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializations
    
    init() {
        fetchPersonsAndUpdateObservableData()
    }

    // MARK: - Public Functions
    
    public func getAllPersons() -> BehaviorRelay<[PersonsModel]> {
        return persons
    }

    // MARK: - Private Functions
    
    private func fetchPersonsAndUpdateObservableData() {
        DatabaseManager.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext: { (person) in
                self.persons.accept(person)
            })
            .disposed(by: disposeBag)
    }
}
