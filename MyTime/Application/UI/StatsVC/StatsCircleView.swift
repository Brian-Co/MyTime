//
//  StatsCircleView.swift
//  MyTime
//
//  Created by Brian Corrieri on 24/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit


class StatsCircleView: UIView {
    
    
    var timers: [TimerX] = []
    
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineWidth = 60
        backgroundLayer.strokeColor = UIColor.quaternarySystemFill.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.frame = bounds
        
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: -CGFloat.pi/2,
        endAngle: (2 * CGFloat.pi) - CGFloat.pi/2, clockwise: true)
        backgroundLayer.path = circularPath.cgPath
        
        return backgroundLayer
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(with timers: [TimerX]) {
        
        self.timers = timers
        loadLayers()
    }
    
    private func loadLayers() {
        
        layer.sublayers = nil
        layer.addSublayer(backgroundLayer)
        
        createStatsLayers()
    }
    
    
    func createStatsLayers() {
        
        let timersTotalDuration = getAllTimersTotalDuration()
        var previousTimerEndAngle: Double = 0
        
        for timer in timers {
            
            let timerTotalDuration = getTotalDuration(for: timer)
            if timerTotalDuration > 0 {
                let timerPercentage = timerTotalDuration / timersTotalDuration
                let startAngle = previousTimerEndAngle + 0.003
                var endAngle: Double = 0
                if previousTimerEndAngle + timerPercentage >= 1 {
                    endAngle = 1
                } else {
                    endAngle = startAngle + timerPercentage
                    previousTimerEndAngle = endAngle
                }
                createStatLayer(startAngle, endAngle, timer.color)
            }
        }
    }
    
    func createStatLayer(_ startAngle: Double, _ endAngle: Double, _ color: String) {
        
        let timerIntervalLayer = CAShapeLayer()
        timerIntervalLayer.lineWidth = 60
        timerIntervalLayer.strokeColor = TimerColor(rawValue: color)?.create.cgColor
        timerIntervalLayer.fillColor = UIColor.clear.cgColor
        timerIntervalLayer.frame = bounds
        
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let startAngle = (2 * CGFloat.pi * CGFloat(startAngle)) - CGFloat.pi/2
        let endAngle = (2 * CGFloat.pi * CGFloat(endAngle)) - CGFloat.pi/2
        
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: startAngle,
                                        endAngle: endAngle, clockwise: true)
        timerIntervalLayer.path = circularPath.cgPath
        
        layer.addSublayer(timerIntervalLayer)
    }
    
    func getAllTimersTotalDuration() -> Double {
        
        var totalDuration: Double = 0
        for timer in timers {
            totalDuration += getTotalDuration(for: timer)
        }
        
        return totalDuration
    }
    
    func getTotalDuration(for timer: TimerX) -> Double {
        
        if !timer.timerIntervals.isEmpty {
            var totalDuration: Double = 0
            for timerInterval in timer.timerIntervals {
                if let endingPoint = timerInterval.endingPoint {
                    let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                    totalDuration += timerIntervalDuration
                }
            }
            return totalDuration
        }
        return 0
    }
    
}
