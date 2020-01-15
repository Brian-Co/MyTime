//
//  APITimersDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 07/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift


class APITimersDataSource: TimersDataSource {
    
    var content: [TimerX] = []
    var contentDidChange: (() -> ())?
    var stateDidChange: ((DataSourceState) -> ())?
    
    let realm = try! Realm()
    var observer: NotificationToken?
    
    func fetchData() {
        
        observer = realm.objects(TimerRealm.self).observe({ changes in
            let timers = self.realm.objects(TimerRealm.self)
            
            if timers.count > 0 {
                
                self.content = timers.map { TimerX(name: $0.name, color: $0.color, category: $0.category, timerIntervals: $0.timerIntervals.map { TimerInterval(startingPoint: $0.startingPoint, endingPoint: $0.endingPoint) }) }
            } else {
                
                let timer = TimerRealm()
                timer.name = "First Timer"
                timer.color = "orange"
                
                try! self.realm.write {
                    self.realm.add(timer)
                }
                
                let timerX = TimerX(name: timer.name, color: timer.color, category: "", timerIntervals: [])
                self.content.append(timerX)
            }
            
            self.contentDidChange?()
//            self.stateDidChange?(DataSourceState.data)
        })
    }
    
    func deleteTimer(_ timerName: String) {
        
        guard let timerToDelete = realm.objects(TimerRealm.self).filter("name = '\(timerName)'").first else { return }
        
        try! realm.write {
            realm.delete(timerToDelete)
        }
    }
        
}


