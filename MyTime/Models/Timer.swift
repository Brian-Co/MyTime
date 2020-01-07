//
//  Timer.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

class Timer: Object {
    
    var name: String = ""
    var color: String = ""
    var timerIntervals: [TimerInterval] = []
    
}
