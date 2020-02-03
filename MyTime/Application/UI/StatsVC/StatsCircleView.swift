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
    var period: Period!
    
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
    
    func update(with timers: [TimerX], period: Period) {
        
        self.timers = timers
        self.period = period
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
        animate(timerIntervalLayer)
    }
    
    private func animate(_ layer: CAShapeLayer) {
        let foregroundAnimation = CABasicAnimation(keyPath: "strokeEnd")
        foregroundAnimation.fromValue = 0
        foregroundAnimation.toValue = 1
        foregroundAnimation.duration = CFTimeInterval(0.8)
        foregroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        foregroundAnimation.fillMode = CAMediaTimingFillMode.forwards
        foregroundAnimation.isRemovedOnCompletion = false
        
        layer.add(foregroundAnimation, forKey: "foregroundAnimation")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loadLayers()
    }
    
    func getAllTimersTotalDuration() -> Double {
        
        var totalDuration: Double = 0
        for timer in timers {
            totalDuration += getTotalDuration(for: timer)
        }
        
        return totalDuration
    }
    
    func getTotalDuration(for timer: TimerX) -> Double {
        
        let totalDuration = timer.timerIntervals.reduce(Double(0), { result, timerInterval in
            
            var totalDuration = result
            
            if !isTimerIntervalWithinPeriod(timerInterval) {
                return totalDuration
            } else {
                if let endingPoint = timerInterval.endingPoint {
                    let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                    totalDuration += timerIntervalDuration
                }
                return totalDuration
            }
        })
        
        return totalDuration
    }
    
    func isTimerIntervalWithinPeriod(_ timerInterval: TimerInterval) -> Bool {
        
        switch period {
        case .today:
            if Calendar.current.isDate(timerInterval.startingPoint, inSameDayAs: Date()) {
                return true
            }
            return false
        case .yesterday:
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            if Calendar.current.isDate(timerInterval.startingPoint, inSameDayAs: yesterday) {
                return true
            }
            return false
        case .last7Days:
            let last7Days = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            if timerInterval.startingPoint.isBetween(last7Days, and: Date()) {
                return true
            }
            return false
        case .last30Days:
            let last30Days = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            if timerInterval.startingPoint.isBetween(last30Days, and: Date()) {
                return true
            }
            return false
        default:
            return true
        }
        
    }
    
}
