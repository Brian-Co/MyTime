//
//  Timer.swift
//  MyTime
//
//  Created by Brian Corrieri on 07/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

class TimerX {
    
    var name: String
    var color: String
    var category: String
    var timerIntervals: [TimerInterval]
    
    var isOn: Bool { return timerIntervals.last?.isOn == true }
    
    init(name: String, color: String, category: String, timerIntervals: [TimerInterval]) {
        self.name = name
        self.color = color
        self.category = category
        self.timerIntervals = timerIntervals
    }
    
}
