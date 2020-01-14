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
    
    func fetchData() {
        
        let timers = realm.objects(TimerRealm.self)
        if timers.count > 0 {
            
            content = timers.map { TimerX(name: $0.name, color: $0.color, category: $0.category, timerIntervals: $0.timerIntervals.map { TimerInterval(startingPoint: $0.startingPoint, duration: $0.duration) }) }
        } else {
            
            let timer = TimerRealm()
            timer.name = "First Timer"
            timer.color = "orange"
            
            try! realm.write {
                realm.add(timer)
            }
            
            let timerX = TimerX(name: timer.name, color: timer.color, category: "", timerIntervals: [])
            content.append(timerX)
        }
        
        self.contentDidChange?()
//        self.stateDidChange?(DataSourceState.data)
    }
    
    func updateTimer(_ timer: TimerX) {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first
        let timerInterval = timer.timerIntervals.last!
        let timerIntervalRealm = TimerIntervalRealm(value: [timerInterval.startingPoint, timerInterval.duration])
        
        try! realm.write {
            timerToUpdate?.timerIntervals.append(timerIntervalRealm)
        }
        
        fetchData()
    }
    
    func editTimer(_ timer: TimerX, name: String, color: String) {
        
        let timerToEdit = realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first
        
        try! realm.write {
            timerToEdit?.name = name
            timerToEdit?.color = color
        }
        
        fetchData()
    }
    
    func createTimer(name: String, color: String) {
        
        let timer = TimerRealm()
        timer.name = name
        timer.color = color
        
        try! realm.write {
            realm.add(timer)
        }
        
        fetchData()
    }
    
    func deleteTimer(_ timer: TimerX) {
        
        guard let timerToDelete = realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first else { return }
        
        try! realm.write {
            realm.delete(timerToDelete)
        }
        
        fetchData()
    }
        
    
}


