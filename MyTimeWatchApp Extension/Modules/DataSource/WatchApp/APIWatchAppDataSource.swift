//
//  APIWatchAppDataSource.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift

class APIWatchAppDataSource: ObservableObject {
    
    @Published var content: [TimerX] = []
    
    var timerObserver: NotificationToken?
    var timerIntervalObserver: NotificationToken?
    var runningTimers: [Timer] = []
    
    init(preview: Bool = false) {
        if preview {
            content.append(TimerX(id: "1", name: "Timer XYZ", color: "orange", category: "", timerIntervals: [TimerInterval(id: "1", startingPoint: Calendar.current.date(byAdding: .minute, value: -3, to: Date())! , endingPoint: nil)]))
            content.append(TimerX(id: "2", name: "Second timer", color: "teal", category: "", timerIntervals: [TimerInterval(id: "1", startingPoint: Calendar.current.date(byAdding: .hour, value: -3, to: Date())! , endingPoint: Date())]))
            content.append(TimerX(id: "3", name: "Third timer", color: "purple", category: "", timerIntervals: []))
            scheduleTimer()
        } else {
            fetchData()
        }
    }
    
    func fetchData() {

        let realm = try! Realm()
        timerObserver = realm.objects(TimerRealm.self).observe({ changes in
            let timers = realm.objects(TimerRealm.self).sorted{ $0.index < $1.index }
            
//            if timers.count > 0 {
                self.content = timers.compactMap { $0.toAppModel() }
//            } else {
//
//                let timer = TimerRealm()
//                timer.name = "First Project"
//                timer.color = "orange"
//
//                try! self.realm.write {
//                    self.realm.add(timer)
//                }
//
//                let timerX = timer.toAppModel()!
//                self.content.append(timerX)
//            }
        })
        
        timerIntervalObserver = realm.objects(TimerIntervalRealm.self).observe({ changes in
            
            let timers = realm.objects(TimerRealm.self).sorted{ $0.index < $1.index }
            self.content = timers.compactMap { $0.toAppModel() }
            self.scheduleTimer()
            
            let intervals = realm.objects(TimerIntervalRealm.self).filter({ !$0.isDeleted })
            print("update \(intervals.count)")
        })
        
    }
    
    func scheduleTimer() {
        
        var index = 0
        for runningTimer in runningTimers {
            runningTimer.invalidate()
        }
        runningTimers = []
        
        for timerX in content {
            let myIndex = index
            print("\(timerX.name) index \(index)")
            self.content[myIndex].totalDurationString = timerX.totalDuration.timeString(format: 1)
            let scheduleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                if timerX.isOn {
                    self.content[myIndex].elapsedTimeString = timerX.elapsedTime.timeString()
                    self.content[myIndex].totalDurationString = (timerX.totalDuration + timerX.elapsedTime).timeString(format: 1)
                } else {
                    timer.invalidate()
                    print("invalidate")
                }
            })
            runningTimers.append(scheduleTimer)
            index += 1
        }
    }
    
    
    func timerButtonPressed(_ timer: TimerX) {
        
        if timer.isOn {
            stopTimer(timer)
        } else {
            startTimer(timer)
        }
    }
    
    func startTimer(_ timer: TimerX) {
        
        var timer = timer
        let timerInterval = TimerInterval(id: NSUUID().uuidString, startingPoint: Date(), endingPoint: nil)
        timer.timerIntervals.append(timerInterval)
        updateTimer(timer)
    }
    
    func stopTimer(_ timer: TimerX) {
        
        var timer = timer
        if timer.elapsedTime > 60 {
            var timerIntervalToAppend = timer.timerIntervals.last!
            timerIntervalToAppend.endingPoint = Date()
            timer.timerIntervals.removeLast()
            timer.timerIntervals.append(timerIntervalToAppend)
            updateTimer(timer)
        } else {
            timer.timerIntervals.removeLast()
            updateTimer(timer)
        }
    }
    
    func updateTimer(_ timer: TimerX) {
        
        let realm = try! Realm()
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer.name)' AND isDeleted = false").first
        let timerIntervalToUpdate = realm.objects(TimerIntervalRealm.self).filter{ $0.timerID == timerToUpdate?.id }.last
        
        if timer.isOn {
            let timerIntervalRealm = TimerIntervalRealm()
            timerIntervalRealm.startingPoint = timer.timerIntervals.last!.startingPoint
            timerIntervalRealm.endingPoint = timer.timerIntervals.last!.endingPoint
            timerIntervalRealm.timer = timerToUpdate
            timerIntervalRealm.timerID = timerToUpdate?.id ?? ""
            
            try! realm.write {
                realm.add(timerIntervalRealm)
            }
        } else {
            if timerIntervalToUpdate?.startingPoint != timer.timerIntervals.last?.startingPoint {
                //Delete timerInterval that's less than 30sec long
                let timerIntervalToDelete = timerToUpdate?.timerIntervals.last
                try! realm.write {
                    timerIntervalToUpdate?.isDeleted = true
                }
            } else {
                try! realm.write {
                    timerIntervalToUpdate?.endingPoint = timer.timerIntervals.last!.endingPoint
                }
            }
        }
    }
    
    func addTimer() {
        
        let realm = try! Realm()
        let timers = realm.objects(TimerRealm.self).sorted{ $0.index < $1.index }
        
        let newTimer = TimerRealm()
        newTimer.index = (timers.last?.index ?? -1) + 1
        newTimer.name = "Timer " + String(newTimer.index + 1)
        newTimer.color = TimerColor.allCases.randomElement()!.rawValue
        
        try! realm.write {
            realm.add(newTimer)
        }
    }
    
    
}
