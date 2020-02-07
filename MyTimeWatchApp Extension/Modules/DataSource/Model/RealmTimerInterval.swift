//
//  RealmTimerInterval.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

final class TimerIntervalRealm: Object {
    
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var startingPoint: Date = Date()
    @objc dynamic var endingPoint: Date? = nil
    @objc dynamic var isDeleted: Bool = false
    
    @objc dynamic var timer: TimerRealm?
    @objc dynamic var timerID: String = ""
    
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
        return TimerInterval(id: id, startingPoint: startingPoint, endingPoint: endingPoint)
    }
    
}

extension TimerIntervalRealm: CKRecordConvertible {
    
}

extension TimerIntervalRealm: CKRecordRecoverable {
    
}

