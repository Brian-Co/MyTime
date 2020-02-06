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
        self.timers = timers.compactMap { $0.toAppModel() }
    }
    
    
    func deleteInterval() {
        
        guard let timerIntervalRealm = realm.objects(TimerIntervalRealm.self).filter("startingPoint == %@ AND endingPoint == %@ AND isDeleted = false", originalTimerInterval.startingPoint, originalTimerInterval.endingPoint!).first else { return }
                
        try! realm.write {
            timerIntervalRealm.isDeleted = true
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
        
        guard let timerIntervalRealm = realm.objects(TimerIntervalRealm.self).filter("startingPoint == %@ AND endingPoint == %@ AND isDeleted = false", originalTimerInterval.startingPoint, originalTimerInterval.endingPoint!).first else { return }
        
        try! realm.write {
            timerIntervalRealm.startingPoint = timerInterval.startingPoint
            timerIntervalRealm.endingPoint = timerInterval.endingPoint!
        }
    }
    
    func createInterval() {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer!.name)' AND isDeleted = false").first
        let timerIntervalToUpdate = realm.objects(TimerIntervalRealm.self).filter{ $0.timerID == timerToUpdate?.id }.last
        
        let timerIntervalRealm = TimerIntervalRealm()
        timerIntervalRealm.startingPoint = timerInterval.startingPoint
        timerIntervalRealm.endingPoint = timerInterval.endingPoint!
        timerIntervalRealm.timer = timerToUpdate
        timerIntervalRealm.timerID = timerToUpdate?.id ?? ""
        
        if timer!.isOn {
            try! realm.write {
                timerIntervalToUpdate?.endingPoint = Date()
            }
        }
        
        try! realm.write {
            realm.add(timerIntervalRealm)
        }
    }
    
    
}
