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
    var timerObserver: NotificationToken?
    var timerIntervalObserver: NotificationToken?
    
    ///To avoid contentDidChange method to be fired twice in a row at launch
    var firstTime = true
    
    func fetchData() {
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        timerObserver = realm.objects(TimerRealm.self).observe({ changes in
            let timers = self.realm.objects(TimerRealm.self)
            
            if timers.count > 0 {
                
                self.content = timers.compactMap { $0.toAppModel() }
            } else {
                
                let timer = TimerRealm()
                timer.name = "First Project"
                timer.color = "orange"
                
                try! self.realm.write {
                    self.realm.add(timer)
                }
                
                let timerX = timer.toAppModel()!
                self.content.append(timerX)
            }
            
            if !self.firstTime {
                self.contentDidChange?()
            }
        })
        
        timerIntervalObserver = realm.objects(TimerIntervalRealm.self).observe({ changes in
            
            let timers = self.realm.objects(TimerRealm.self)
            self.content = timers.compactMap { $0.toAppModel() }
            self.contentDidChange?()
            self.firstTime = false
        })
        
    }
    
    func deleteTimer(_ timerName: String) {
        
        guard let timerToDelete = realm.objects(TimerRealm.self).filter("name = '\(timerName)' AND isDeleted = false").first else { return }
        
        try! realm.write {
            timerToDelete.isDeleted = true
        }
    }
    
    func updateTimer(_ timer: TimerX) {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer.name)' AND isDeleted = false").first
        
        if timer.isOn {
            let timerIntervalRealm = TimerIntervalRealm()
            timerIntervalRealm.startingPoint = timer.timerIntervals.last!.startingPoint
            timerIntervalRealm.endingPoint = timer.timerIntervals.last!.endingPoint
            timerIntervalRealm.timer = timerToUpdate
            
            try! realm.write {
                realm.add(timerIntervalRealm)
            }
        } else {
            if timerToUpdate?.timerIntervals.last?.startingPoint != timer.timerIntervals.last?.startingPoint {
                //Delete timerInterval that's less than 30sec long
                let timerIntervalToDelete = timerToUpdate?.timerIntervals.last
                try! realm.write {
                    timerIntervalToDelete?.isDeleted = true
                }
            } else {
                try! realm.write {
                    timerToUpdate?.timerIntervals.last?.endingPoint = timer.timerIntervals.last!.endingPoint
                }
            }
        }
    }
        
}


