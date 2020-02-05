//
//  Timer.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

final class TimerRealm: Object {
    
    @objc dynamic var id: String = NSUUID().uuidString
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
        return TimerX(name: name, color: color, category: category, timerIntervals: [TimerInterval](timerIntervals.compactMap({ $0.toAppModel() })))
    }
    
}
