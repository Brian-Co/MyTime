//
//  EditTimerHandler.swift
//  MyTime
//
//  Created by Brian Corrieri on 14/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

class EditTimerHandler {
    
    weak var delegate: EditTimerHandlerDelegate?
    private var dataSource: TimersDataSource!
    private var timer: TimerX?
    
    init(dataSource: TimersDataSource, delegate: EditTimerHandlerDelegate, timer: TimerX?) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.timer = timer
    }
    
    func isDoneEditingTimer(timerName: String, timerColor: String?) {
        
        if timerNameIsEmpty(timerName: timerName) {
            return
        }
        
        if timerNameExists(timerName: timerName) {
            return
        }
        
        let color = unwrapTimerColor(timerColor: timerColor)
        
        if self.timer != nil {
            dataSource.editTimer(self.timer!, name: timerName, color: color)
        } else {
            dataSource.createTimer(name: timerName, color: color)
        }
        
        delegate?.dismissVC()
        
    }
    
    
    func unwrapTimerColor(timerColor: String?) -> String {
        if let color = timerColor {
            return color
        } else {
            return "orange"
        }
    }
    
    func timerNameIsEmpty(timerName: String) -> Bool {
        
        let name = timerName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            delegate?.showAlert(title: "Timer name is empty", message: "You must enter a timer name")
            return true
        }
        return false
    }
    
    func timerNameExists(timerName: String) -> Bool {
        
        if timerName != timer?.name {
            for timer in dataSource.content {
                if timer.name == timerName {
                    delegate?.showAlert(title: "Timer already exists", message: "You must enter a different timer name")
                    return true
                }
            }
        }
        return false
    }
    
}
