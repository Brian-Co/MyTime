//
//  TimersDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 07/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol TimersDataSource {
    
    var content: [TimerX] { get set }
    var contentDidChange: (() -> ())? { get set }
    var stateDidChange: ((_ state: DataSourceState) -> ())? { get set }
    
    func fetchData()
    func updateTimer(_ timer: TimerX)
    func editTimer(_ timer: TimerX, name: String, color: String)
    func createTimer(name: String, color: String)
    func deleteTimer(_ timer: TimerX)
    
}

enum DataSourceState {
    
    case noData
    case loading
    case dataAndLoading
    case data
    case error(_ error: Error)
    
}
