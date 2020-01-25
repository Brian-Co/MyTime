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
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        observer = realm.objects(TimerRealm.self).observe({ changes in
            let timers = self.realm.objects(TimerRealm.self)
            
            if timers.count > 0 {
                
                self.content = timers.compactMap { $0.toAppModel() }
            } else {
                
                let timer = TimerRealm()
                timer.name = "First Timer"
                timer.color = "orange"
                
                try! self.realm.write {
                    self.realm.add(timer)
                }
                
                let timerX = timer.toAppModel()!
                self.content.append(timerX)
            }
            
            self.contentDidChange?()
        })
    }
    
    func deleteTimer(_ timerName: String) {
        
        guard let timerToDelete = realm.objects(TimerRealm.self).filter("name = '\(timerName)'").first else { return }
        
        try! realm.write {
            realm.delete(timerToDelete)
        }
    }
    
    func updateTimer(_ timer: TimerX) {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first
        
        if timer.isOn {
            let timerIntervalRealm = TimerIntervalRealm(value: [timer.timerIntervals.last!.startingPoint, timer.timerIntervals.last!.endingPoint])
            
            try! realm.write {
                timerToUpdate?.timerIntervals.append(timerIntervalRealm)
            }
        } else {
            if timerToUpdate?.timerIntervals.last?.startingPoint != timer.timerIntervals.last?.startingPoint {
                let timerIntervalToDelete = timerToUpdate?.timerIntervals.last
                try! realm.write {
                    realm.delete(timerIntervalToDelete!)
                }
            } else {
                try! realm.write {
                    timerToUpdate?.timerIntervals.last?.endingPoint = timer.timerIntervals.last!.endingPoint
                }
            }
        }
    }
        
}


