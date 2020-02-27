//
//  Timer.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

final class TimerRealm: Object {
    
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var index: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var isDeleted: Bool = false
    
    let timerIntervals: LinkingObjects<TimerIntervalRealm> = LinkingObjects(fromType: TimerIntervalRealm.self, property: "timer")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

extension TimerRealm: CodableForAppModel {
    
    static func from(appModel: TimerX) -> TimerRealm? {
        let timer: TimerRealm = TimerRealm()
        timer.name = appModel.name
        timer.color = appModel.color
        timer.category = appModel.category
        return timer
    }
    
    func toAppModel() -> TimerX? {
        if isDeleted { return nil }
        let realm = try! Realm()
        let timerIntervals = realm.objects(TimerIntervalRealm.self).filter{ $0.timerID == self.id }
        let timerIntervalsSorted = timerIntervals.sorted {
            guard $0.endingPoint != nil else { return false }
            return $0.startingPoint < $1.startingPoint
        }
        return TimerX(index: index, name: name, color: color, category: category, timerIntervals: [TimerInterval](timerIntervalsSorted.compactMap({ $0.toAppModel() })))
    }
    
}

extension TimerRealm: CKRecordConvertible {
    
}

extension TimerRealm: CKRecordRecoverable {
    
}
