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
    
    func createTimerIntervalsLayers() {
        
        for timer in timers {
            for timerInterval in timer.timerIntervals {
                if let endingPoint = timerInterval.endingPoint {
                    let startAngle = getAngle(for: timerInterval.startingPoint)
                    let endAngle = getAngle(for: endingPoint)
                    createTimerIntervalLayer?(startAngle, endAngle, timer.color)
                }
            }
        }
    }
    
    private func getAngle(for date: Date) -> Double {
        
        let calendar = Calendar(identifier: .gregorian)
        let midnight = calendar.startOfDay(for: date)
        let minutes = date.timeIntervalSince(midnight) / 60
        let Angle = minutes / 1440
        
        return Angle
    }
    
}
