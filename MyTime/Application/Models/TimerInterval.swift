//
//  TimerInterval.swift
//  MyTime
//
//  Created by Brian Corrieri on 07/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

class TimerInterval {
    
    var startingPoint: Date
    var endingPoint: Date?
    
    var isOn: Bool { return endingPoint == nil }
    
    init(startingPoint: Date, endingPoint: Date?) {
        self.startingPoint = startingPoint
        self.endingPoint = endingPoint
    }
    
}
