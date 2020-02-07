//
//  TimerWatch.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

struct TimerX: Identifiable {
    
    var id: String
    var name: String
    var color: String
    var category: String
    var timerIntervals: [TimerInterval]
    
    var isOn: Bool { return timerIntervals.last?.isOn == true }
        
    var elapsedTimeString = ""
    var elapsedTime: Int {
        
        if isOn {
            let startingPoint = timerIntervals.last!.startingPoint
            let elapsedTime = Int(Date().timeIntervalSince(startingPoint))
            return elapsedTime
        } else {
            return 0
        }
    }
    
    var totalDurationString = ""
    var totalDuration: Int {
        
        let totalDuration = timerIntervals.reduce(0, { result, timerInterval in
            
            var totalDuration = result
            if let endingPoint = timerInterval.endingPoint, Calendar.current.isDate(timerInterval.startingPoint, inSameDayAs: Date()) {
                let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                totalDuration += Int(timerIntervalDuration)
            }
            return totalDuration
        })
        
        return totalDuration
    }
    
    var buttonColor: String {
        
        if isOn {
            return color
        } else {
            return "clear"
        }
    }
            
}

