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
   
    var timer: TimerX?
    var timerInterval: TimerInterval
    var dismissVC: (() -> ())?
    
    var originalTimerInterval: TimerInterval
    
    let realm = try! Realm()
    
    init(timer: TimerX?, timerInterval: TimerInterval) {
        self.timer = timer
        self.timerInterval = timerInterval
        self.originalTimerInterval = TimerInterval(startingPoint: timerInterval.startingPoint, endingPoint: timerInterval.endingPoint)
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
                
                guard let timerIntervalRealm = realm.objects(TimerIntervalRealm.self).filter("startingPoint == %@ AND endingPoint == %@", originalTimerInterval.startingPoint, originalTimerInterval.endingPoint!).first else { return }
                
                try! realm.write {
                    timerIntervalRealm.startingPoint = timerInterval.startingPoint
                    timerIntervalRealm.endingPoint = timerInterval.endingPoint!
                }
            }
        }
        
        dismissVC?()
    }
    
    
}
