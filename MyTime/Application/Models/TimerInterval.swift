//
//  TimerInterval.swift
//  MyTime
//
//  Created by Brian Corrieri on 07/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

struct TimerInterval {
    
    var startingPoint: Date
    var endingPoint: Date?
    
    var isOn: Bool { return endingPoint == nil }
    
}
