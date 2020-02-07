//
//  TimerIntervalWatch.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

struct TimerInterval: Identifiable {
    
    var id: String
    var startingPoint: Date
    var endingPoint: Date?
    
    var isOn: Bool { return endingPoint == nil }
    
}
