//
//  APITodayDataSource.swift
//  MyTime Today Extension
//
//  Created by Brian Corrieri on 27/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream
import CloudKit

class APITodayDataSource: TodayDataSource {
    
    var syncEngine: SyncEngine?
    var updateUI: ((_ timer: TimerX) -> ())?
    
    var timerObserver: NotificationToken?
    var timerIntervalObserver: NotificationToken?
    
    init(updateUIBlock: ((_ timer: TimerX) -> ())?) {
        self.updateUI = updateUIBlock
        start()
    }
    
    func start() {
        
        let appGroupUrl = FileManager
        .default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.FairTrip.MyTime")!
        .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: appGroupUrl,
        objectTypes: [TimerRealm.self, TimerIntervalRealm.self])
        
        Realm.Configuration.defaultConfiguration = config
        
        syncEngine = SyncEngine(objects: [
                SyncObject<TimerRealm>(),
                SyncObject<TimerIntervalRealm>()
            ], databaseScope: .private, container: CKContainer(identifier: "iCloud.FairTrip.MyTime"))
        
        let realm = try! Realm()
        timerObserver = realm.objects(TimerRealm.self).observe { changes in
            
            self.updateUI?(self.lastTimerUsed())
        }
        
        timerIntervalObserver = realm.objects(TimerIntervalRealm.self).observe { changes in
            
            self.updateUI?(self.lastTimerUsed())
        }
    }
    
    func update(_ timer: TimerX) {
        
        let realm = try! Realm()
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer.name)' AND isDeleted = false").first
        let timerIntervalToUpdate = realm.objects(TimerIntervalRealm.self).filter { ($0.timerID == timerToUpdate?.id) && !$0.isDeleted }.last
        
        if timer.isOn {
            let timerIntervalRealm = TimerIntervalRealm()
            timerIntervalRealm.startingPoint = timer.timerIntervals.last!.startingPoint
            timerIntervalRealm.endingPoint = timer.timerIntervals.last!.endingPoint
            timerIntervalRealm.timer = timerToUpdate
            timerIntervalRealm.timerID = timerToUpdate?.id ?? ""
            
            try! realm.write {
                realm.add(timerIntervalRealm)
                syncEngine?.pushAll()
            }
        } else {
            if timerIntervalToUpdate?.startingPoint != timer.timerIntervals.last?.startingPoint {
                //Delete timerInterval that's less than 30sec long
                let timerIntervalToDelete = timerToUpdate?.timerIntervals.last
                try! realm.write {
                    timerIntervalToUpdate?.isDeleted = true
                    syncEngine?.pushAll()
                }
            } else {
                try! realm.write {
                    timerIntervalToUpdate?.endingPoint = timer.timerIntervals.last!.endingPoint
                    syncEngine?.pushAll()
                }
            }
        }
        
    }
    
    func addTimer() {
        
        let realm = try! Realm()
        let timers = realm.objects(TimerRealm.self).sorted{ $0.index < $1.index }
        
        let newTimer = TimerRealm()
        newTimer.index = (timers.last?.index ?? -1) + 1
        newTimer.name = "Bibou" + String(newTimer.index)
        newTimer.color = "orange"
        
        try! realm.write {
            realm.add(newTimer)
            print("changed to Boo Ya")
        }
        
        syncEngine?.pushAll()
    }
    
    func lastTimerUsed() -> TimerX {
        
        let realm = try! Realm()
        let timers = realm.objects(TimerRealm.self).filter("isDeleted = false")
            .sorted { $0.index < $1.index }
        let timerIntervals = realm.objects(TimerIntervalRealm.self).filter("isDeleted = false")
            .sorted { $0.startingPoint < $1.startingPoint }
        let lastUsedTimer = timers.filter { $0.id == timerIntervals.last?.timerID }
        
        if !lastUsedTimer.isEmpty {
            return lastUsedTimer.first!.toAppModel()!
        } else if !timers.isEmpty {
            return timers.first!.toAppModel()!
        } else {
            let timer = TimerX(index: -1, name: "Add Timer", color: "orange", category: "", timerIntervals: [])
            return timer
        }
    }
    
}
