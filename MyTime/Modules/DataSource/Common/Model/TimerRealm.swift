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
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var category: String = ""
    let timerIntervals: List<TimerIntervalRealm> = List<TimerIntervalRealm>()
    
}

extension TimerRealm: CodableForAppModel {
    
    static func from(appModel: TimerX) -> TimerRealm? {
        let timer: TimerRealm = TimerRealm()
        timer.name = appModel.name
        timer.color = appModel.color
        timer.category = appModel.category
        timer.timerIntervals.append(objectsIn: appModel.timerIntervals.compactMap({ TimerIntervalRealm.from(appModel: $0) }))
        return timer
    }
    
    func toAppModel() -> TimerX? {
        return TimerX(name: name, color: color, category: category, timerIntervals: [TimerInterval](timerIntervals.compactMap({ $0.toAppModel() })))
    }
    
}
