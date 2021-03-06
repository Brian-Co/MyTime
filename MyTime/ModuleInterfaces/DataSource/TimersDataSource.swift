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
    func deleteTimer(_ timerName: String)
    func updateTimer(_ timer: TimerX)
    func updateTimerIndexes()
    
}

enum DataSourceState {
    
    case noData
    case loading
    case dataAndLoading
    case data
    case error(_ error: Error)
    
}
