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
            
            print(content)
            
        } else {
            
            let timer = TimerRealm()
            timer.name = "First Timer"
            timer.timerIntervals.append(TimerIntervalRealm())
            
            try! realm.write {
                realm.add(timer)
                print("creating realm objects")
            }
            
        }
        
        self.contentDidChange?()
        self.stateDidChange?(DataSourceState.data)
        
        
    }
    
    func updateTimer(_ timer: TimerX) {
        
        let timerToUpdate = realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first
        let timerInterval = timer.timerIntervals.last!
        let timerIntervalRealm = TimerIntervalRealm(value: [timerInterval.startingPoint, timerInterval.duration])
        
        try! realm.write {
            timerToUpdate?.timerIntervals.append(timerIntervalRealm)
        }
        
        updateContent()
    }
    
    func updateContent() {
        
        let timers = realm.objects(TimerRealm.self)
        content = timers.map { TimerX(name: $0.name, color: $0.color, category: $0.category, timerIntervals: $0.timerIntervals.map { TimerInterval(startingPoint: $0.startingPoint, duration: $0.duration) }) }
        
        self.contentDidChange?()
    }
        
    
}


