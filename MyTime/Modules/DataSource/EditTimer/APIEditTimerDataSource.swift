//
//  APIEditTimerDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 15/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift


class APIEditTimerDataSource: EditTimerDataSource {
    
    var timer: TimerX
    var showAlert: ((String, String) -> ())?
    var dismissVC: (() -> ())?
    
    let realm = try! Realm()
    var timerName: String?
    
    init(timer: TimerX?) {
        if let timer = timer {
            self.timer = timer
            self.timerName = timer.name
        } else {
            let timers = realm.objects(TimerRealm.self).filter("isDeleted = false").sorted{ $0.index < $1.index }
            let newIndex = (timers.last?.index ?? -1) + 1
            self.timer = TimerX(index: newIndex, name: "", color: "orange", category: "", timerIntervals: [])
        }
    }
    
    func save() {
        
        if timerNameIsEmpty() {
            return
        }
        
        if timerNameExists() {
            return
        }
        
        saveTimer()
        dismissVC?()
    }
    
    func timerNameIsEmpty() -> Bool {
        
        let name = timer.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            showAlert?("Timer name is empty", "You must enter a timer name")
            return true
        }
        return false
    }
    
    func timerNameExists() -> Bool {
        
        if timer.name != timerName {
            if realm.objects(TimerRealm.self).filter("name = '\(timer.name)' AND isDeleted = false").first != nil {
                showAlert?("Timer already exists", "You must enter a different timer name")
                return true
            }
        }
        return false
    }
    
    func saveTimer() {
        
        if let timer = timerName {
            
            guard let timerToEdit = realm.objects(TimerRealm.self).filter("name = '\(timer)' AND isDeleted = false").first else { return }
            
            try! realm.write {
                timerToEdit.name = self.timer.name
                timerToEdit.color = self.timer.color
            }
        } else {
            
            let timer = TimerRealm()
            let index = realm.objects(TimerRealm.self).reduce(0, { result, timer in
                var index = result
                if timer.index >= index {
                    index = timer.index + 1
                }
                return index
            })
            timer.index = index
            timer.name = self.timer.name
            timer.color = self.timer.color
            
            try! realm.write {
                realm.add(timer)
            }
        }
    }
    
    func delete() {
        
        guard let timerToDelete = realm.objects(TimerRealm.self).filter("name = '\(timer.name)' AND isDeleted = false").first else { return }
        let timerIntervalsToDelete = realm.objects(TimerIntervalRealm.self).filter{ $0.timerID == timerToDelete.id }
        
        try! realm.write {
            timerToDelete.isDeleted = true
        }
        
        for timerInterval in timerIntervalsToDelete {
            try! realm.write {
                timerInterval.isDeleted = true
            }
        }
        
        dismissVC?()
    }
    
}
