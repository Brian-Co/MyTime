//
//  TimerInterval.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

class TimerIntervalRealm: Object {
    
    @objc dynamic var startingPoint: Date = Date()
    @objc dynamic var duration: TimeInterval = 0.0
    
}
