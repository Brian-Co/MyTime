//
//  Timer.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

class TimerRealm: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var category: String = ""
    let timerIntervals = List<TimerIntervalRealm>()
    
}
