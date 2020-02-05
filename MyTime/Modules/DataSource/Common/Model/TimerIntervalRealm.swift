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
    
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var startingPoint: Date = Date()
    @objc dynamic var endingPoint: Date? = nil
    @objc dynamic var isDeleted: Bool = false
    
    @objc dynamic var timer: TimerRealm?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

extension TimerIntervalRealm: CodableForAppModel {

    static func from(appModel: TimerInterval) -> TimerIntervalRealm? {
        let timerInterval: TimerIntervalRealm = TimerIntervalRealm()
        timerInterval.startingPoint = appModel.startingPoint
        timerInterval.endingPoint = appModel.endingPoint
        return timerInterval
    }
    
    func toAppModel() -> TimerInterval? {
        if isDeleted { return nil }
        return TimerInterval(startingPoint: startingPoint, endingPoint: endingPoint)
    }
    
}
