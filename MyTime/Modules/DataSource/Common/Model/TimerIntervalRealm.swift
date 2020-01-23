//
//  TimerInterval.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

final class TimerIntervalRealm: Object {
    
    @objc dynamic var startingPoint: Date = Date()
    @objc dynamic var endingPoint: Date? = nil
    
}

extension TimerIntervalRealm: CodableForAppModel {

    static func from(appModel: TimerInterval) -> TimerIntervalRealm? {
        let timerInterval: TimerIntervalRealm = TimerIntervalRealm()
        timerInterval.startingPoint = appModel.startingPoint
        timerInterval.endingPoint = appModel.endingPoint
        return timerInterval
    }
    
    func toAppModel() -> TimerInterval? {
        return TimerInterval(startingPoint: startingPoint, endingPoint: endingPoint)
    }
    
}
