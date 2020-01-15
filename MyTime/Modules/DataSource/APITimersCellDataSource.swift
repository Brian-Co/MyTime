//
//  APITimersCellDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 15/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

class APITimersCellDataSource: TimersCellDataSource {
    
    var timer: TimerX?
    var timerTotalDuration = 0
    var updateTimer: ((Int) -> ())?
    
    var scheduledTimer = Timer()
    let realm = try! Realm()
    
    deinit {
        scheduledTimer.invalidate()
    }
    
    func getTimerTotalDuration() -> Int {
        
        if !(timer?.timerIntervals.isEmpty ?? true) {
            var totalDuration = 0
            for timerInterval in timer!.timerIntervals {
                if let endingPoint = timerInterval.endingPoint {
                    let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                    totalDuration += Int(timerIntervalDuration)
                }
            }
            timerTotalDuration = totalDuration
            return totalDuration
        }
        return 0
    }
    
    func timerButtonPressed() {
        
        if timer!.isOn {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        
        let timerInterval = TimerInterval(startingPoint: Date(), endingPoint: nil)
        timer?.timerIntervals.append(timerInterval)
        updateTimer?(0)
        
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            
            if self.timer?.isOn ?? false {
                let startingPoint = self.timer?.timerIntervals.last!.startingPoint
                let elapsedTime = Date().timeIntervalSince(startingPoint!)
                self.updateTimer?(Int(elapsedTime))
            } else {
                timer.invalidate()
            }
        })
    }
    
    func stopTimer() {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer!.name)'").first
        let timerIntervalRealm = TimerIntervalRealm(value: [timer?.timerIntervals.last!.startingPoint, Date()])
        
        try! realm.write {
            timerToUpdate?.timerIntervals.append(timerIntervalRealm)
        }
    }
    
    
}
