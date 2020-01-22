//
//  APIDayCircleViewDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 17/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation


class APIDayCircleViewDataSource: DayCircleViewDataSource {
    
    var timers: [TimerX] = [] {
        didSet {
            loadLayers?()
            createTimerIntervalsLayers()
        }
    }
    var loadLayers: (() -> ())?
    var createTimerIntervalLayer: ((Double, Double, String) -> ())?
    var didSelectInterval: ((_ timer: TimerX?, _ timerInterval: TimerInterval) -> ())?
    
    func createTimerIntervalsLayers() {
        
        for timer in timers {
            for timerInterval in timer.timerIntervals {
                if let endingPoint = timerInterval.endingPoint {
                    let startAngle = timerInterval.startingPoint.minutesSinceMidnight() / 1440
                    let endAngle = endingPoint.minutesSinceMidnight() / 1440
                    createTimerIntervalLayer?(startAngle, endAngle, timer.color)
                }
            }
        }
    }
    
    func findTimerFrom(_ startAngle: Double, _ endAngle: Double) {
        
        let startingPointMinutes = String(format: "%.6f", startAngle * 1440)
        let endingPointMinutes = String(format: "%.6f", endAngle * 1440)
        
        for timer in timers {
            for timerInterval in timer.timerIntervals {
                if let endingPoint = timerInterval.endingPoint {
                    
                    let minutesStartingPoint = String(format: "%.6f", timerInterval.startingPoint.minutesSinceMidnight())
                    let minutesEndingPoint = String(format: "%.6f", endingPoint.minutesSinceMidnight())
                    
                    if minutesStartingPoint == startingPointMinutes && minutesEndingPoint == endingPointMinutes {
                        didSelectInterval?(timer, timerInterval)
                    }
                }
            }
        }
    }
    
    func createTimerIntervalFrom(_ angle: Double) {
        
        let startingPointMinutes = angle * 1440
        let hours = Int(startingPointMinutes / 60)
        let minutes = Int(startingPointMinutes) % 60
        let date = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: Date())!
        
        let newInterval = TimerInterval(startingPoint: date, endingPoint: nil)
        didSelectInterval?(nil, newInterval)
    }
    
}
