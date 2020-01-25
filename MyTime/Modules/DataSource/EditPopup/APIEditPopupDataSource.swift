//
//  APIEditPopupDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 20/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

class APIEditPopupDataSource: EditPopupDataSource {
   
    var timers: [TimerX] = []
    var timer: TimerX?
    var timerInterval: TimerInterval
    var dismissVC: (() -> ())?
    
    var originalTimerInterval: TimerInterval
    
    let realm = try! Realm()
    
    init(timer: TimerX?, timerInterval: TimerInterval) {
        self.timer = timer
        self.timerInterval = timerInterval
        self.originalTimerInterval = TimerInterval(startingPoint: timerInterval.startingPoint, endingPoint: timerInterval.endingPoint)
        let timers = self.realm.objects(TimerRealm.self)
        self.timers = timers.map { TimerX(name: $0.name, color: $0.color, category: $0.category, timerIntervals: $0.timerIntervals.map { TimerInterval(startingPoint: $0.startingPoint, endingPoint: $0.endingPoint) }) }
    }
    
    
    func deleteInterval() {
        
        guard let timerIntervalRealm = realm.objects(TimerIntervalRealm.self).filter("startingPoint == %@ AND endingPoint == %@", originalTimerInterval.startingPoint, originalTimerInterval.endingPoint!).first else { return }
                
        try! realm.write {
            realm.delete(timerIntervalRealm)
        }
        
        dismissVC?()
    }
    
    func saveInterval() {
        
        if timerInterval.startingPoint != originalTimerInterval.startingPoint || timerInterval.endingPoint! != originalTimerInterval.endingPoint {
            if !timerInterval.endingPoint!.timeIntervalSince(timerInterval.startingPoint).isLess(than: 5 * 60) {
                
                if originalTimerInterval.endingPoint != nil {
                    updateInterval()
                } else {
                    createInterval()
                }
            }
        }
        
        dismissVC?()
    }
    
    func updateInterval() {
        
        guard let timerIntervalRealm = realm.objects(TimerIntervalRealm.self).filter("startingPoint == %@ AND endingPoint == %@", originalTimerInterval.startingPoint, originalTimerInterval.endingPoint!).first else { return }
        
        try! realm.write {
            timerIntervalRealm.startingPoint = timerInterval.startingPoint
            timerIntervalRealm.endingPoint = timerInterval.endingPoint!
        }
    }
    
    func createInterval() {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer!.name)'").first
        let timerIntervalRealm = TimerIntervalRealm(value: [timerInterval.startingPoint, timerInterval.endingPoint!])
        
        if timer!.isOn {
            try! realm.write {
                timerToUpdate?.timerIntervals.last?.endingPoint = Date()
            }
        }
        
        try! realm.write {
            timerToUpdate?.timerIntervals.append(timerIntervalRealm)
        }
    }
    
    
}
