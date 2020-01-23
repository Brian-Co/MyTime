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
            self.timer = TimerX(name: "", color: "orange", category: "", timerIntervals: [])
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
            if realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first != nil {
                showAlert?("Timer already exists", "You must enter a different timer name")
                return true
            }
        }
        return false
    }
    
    func saveTimer() {
        
        if let timer = timerName {
            
            guard let timerToEdit = realm.objects(TimerRealm.self).filter("name = '\(timer)'").first else { return }
            
            try! realm.write {
                timerToEdit.name = self.timer.name
                timerToEdit.color = self.timer.color
            }
        } else {
            
            let timer = TimerRealm()
            timer.name = self.timer.name
            timer.color = self.timer.color
            
            try! realm.write {
                realm.add(timer)
            }
        }
    }
    
    func delete() {
        
        guard let timerToDelete = realm.objects(TimerRealm.self).filter("name = '\(timer.name)'").first else { return }
        
        try! realm.write {
            realm.delete(timerToDelete)
        }
        
        dismissVC?()
    }
    
}
