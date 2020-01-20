//
//  APIEditPopupDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 20/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

class APIEditPopupDataSource: EditPopupDataSource {
   
    var timer: TimerX
    var timerInterval: TimerInterval
    
    init(timer: TimerX, timerInterval: TimerInterval) {
        self.timer = timer
        self.timerInterval = timerInterval
    }
    
    
}
