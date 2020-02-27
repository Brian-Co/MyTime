//
//  Timer.swift
//  MyTime
//
//  Created by Brian Corrieri on 07/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

struct TimerX {
    
    var index: Int
    var name: String
    var color: String
    var category: String
    var timerIntervals: [TimerInterval]
    
    var isOn: Bool { return timerIntervals.last?.isOn == true }
    
}
