//
//  TimersCellDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 15/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol TimersCellDataSource {
    
    var timer: TimerX? { get set }
    var timerTotalDuration: Int { get set }
    var updateTimer: ((_ time: Int) -> ())? { get set }
    
    func timerButtonPressed()
    func getTimerTotalDuration() -> Int
    
}
