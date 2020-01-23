//
//  DayCircleView.swift
//  MyTime
//
//  Created by Brian Corrieri on 17/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit


class DayCircleView: UIView {
    
    typealias DidSelectIntervalBlock = ((_ timer: TimerX?, _ timerInterval: TimerInterval) -> ())
        
    var timers: [TimerX] = [] {
        didSet {
            loadLayers()
        }
    }
    var didSelectInterval: ((_ timer: TimerX?, _ timerInterval: TimerInterval) -> ())?
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineWidth = 50
        backgroundLayer.strokeColor = UIColor.quaternarySystemFill.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.frame = bounds
        backgroundLayer.path = circularPath
        
        return backgroundLayer
    }()
    
    private var hoursLabels: CATextLayer {
        let hours = CATextLayer()
        hours.fontSize = 17
        hours.alignmentMode = .center
        hours.foregroundColor = UIColor.label.cgColor
        return hours
    }
    
    private var hoursLines: CAShapeLayer {
        let hoursLines = CAShapeLayer()
        hoursLines.lineWidth = 20
        hoursLines.strokeColor = UIColor.systemGray4.cgColor
        hoursLines.fillColor = UIColor.clear.cgColor
        hoursLines.frame = bounds
        
        return hoursLines
    }
    
    private var circularPath: CGPath {
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: -CGFloat.pi/2,
        endAngle: (2 * CGFloat.pi) - CGFloat.pi/2, clockwise: true)
        return circularPath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(didSelectInterval: DidSelectIntervalBlock?) {
        self.didSelectInterval = didSelectInterval
    }
    
    func update(with timers: [TimerX]) {
        self.timers = timers
    }
    
    private func loadLayers() {
        
        layer.sublayers = nil
        layer.addSublayer(backgroundLayer)
        
        addHoursTextLayers()
        addHoursLines()
        createTimerIntervalsLayers()
    }
    
    private func createTimerIntervalsLayers() {
        
        for timer in timers {
            for timerInterval in timer.timerIntervals {
                let startAngle = timerInterval.startingPoint.minutesSinceMidnight() / 1440
                var endAngle: Double = 0
                var isOn = false
                if let endingPoint = timerInterval.endingPoint {
                    endAngle = endingPoint.minutesSinceMidnight() / 1440
                } else {
                    isOn = true
                    endAngle = Date().minutesSinceMidnight() / 1440
                }
                createTimerIntervalLayer(startAngle, endAngle, timer.color, isOn)
            }
        }
    }
    
    private func createTimerIntervalLayer(_ startAngle: Double, _ endAngle: Double, _ color: String, _ isOn: Bool) {
        
        let timerIntervalLayer = CAShapeLayer()
        timerIntervalLayer.lineWidth = 50
        timerIntervalLayer.strokeColor = TimerColor(rawValue: color)?.create.cgColor
//        timerIntervalLayer.lineCap = .round
        timerIntervalLayer.fillColor = UIColor.clear.cgColor
//        timerIntervalLayer.strokeEnd = 0
        timerIntervalLayer.frame = bounds
        
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let startAngle = (2 * CGFloat.pi * CGFloat(startAngle)) - CGFloat.pi/2
        let endAngle = (2 * CGFloat.pi * CGFloat(endAngle)) - CGFloat.pi/2
        
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: startAngle,
        endAngle: endAngle, clockwise: true)
        timerIntervalLayer.path = circularPath.cgPath
        
        timerIntervalLayer.setValue(startAngle + CGFloat.pi/2, forKey: "startAngle")
        timerIntervalLayer.setValue(endAngle + CGFloat.pi/2, forKey: "endAngle")
        if isOn {
            timerIntervalLayer.setValue(true, forKey: "isOn")
        }
        
        layer.addSublayer(timerIntervalLayer)
    }
    
    func updateActiveLayer() {
        
        for sublayer in layer.sublayers! {
            if let myLayer = sublayer as? CAShapeLayer {
                if myLayer.value(forKey: "isOn") != nil {
                    let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
                    let startAngle = myLayer.value(forKey: "startAngle") as! CGFloat - CGFloat.pi/2
                    let newAngle = Date().minutesSinceMidnight() / 1440
                    let endAngle = (2 * CGFloat.pi * CGFloat(newAngle)) - CGFloat.pi/2
                    let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: startAngle,
                                                    endAngle: endAngle, clockwise: true)
                    myLayer.path = circularPath.cgPath
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let pointAngle = point.angle(from: centerPoint)
        let pointRadius = point.distance(from: centerPoint)
        
        let lowerRadius = (bounds.width / 2) - 50
        let upperRadius = (bounds.width / 2) + 10
        if (lowerRadius...upperRadius).contains(pointRadius) {
            var didSelectInterval = false
            for sublayer in layer.sublayers! {
                if let startAngle = sublayer.value(forKey: "startAngle") as? CGFloat, let endAngle = sublayer.value(forKey: "endAngle") as? CGFloat {
                    if (startAngle...endAngle).contains(pointAngle) {
                        let startAnglePercent = startAngle / (2 * CGFloat.pi)
                        let endAnglePercent = endAngle / (2 * CGFloat.pi)
                        didSelectInterval = true
                        findTimerFrom(Double(startAnglePercent), Double(endAnglePercent))
                    }
                }
            }
            if !didSelectInterval {
                let angle = pointAngle / (2 * CGFloat.pi)
                createTimerIntervalFrom(Double(angle))
            }
        }
    }
    
    private func addHoursTextLayers() {
        
        let hours24 = hoursLabels
        hours24.frame = CGRect(x: bounds.width / 2 - 10, y: 60, width: 20, height: 60)
        hours24.string = "24"
        layer.addSublayer(hours24)
        
        let hours6 = hoursLabels
        hours6.frame = CGRect(x: bounds.width - 100, y: bounds.height / 2 - 10, width: 60, height: 20)
        hours6.string = "6"
        layer.addSublayer(hours6)
        
        let hours12 = hoursLabels
        hours12.frame = CGRect(x: bounds.width / 2 - 10, y: bounds.height - 80, width: 20, height: 60)
        hours12.string = "12"
        layer.addSublayer(hours12)
        
        let hours18 = hoursLabels
        hours18.frame = CGRect(x: 40, y: bounds.height / 2 - 10, width: 60, height: 20)
        hours18.string = "18"
        layer.addSublayer(hours18)
    }
    
    private func addHoursLines() {
        
        var dayMinutes: CGFloat = 0
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        
        while dayMinutes < 1440 {
            
            let hourLine = hoursLines
            let start: CGFloat = dayMinutes / 1440
            let end: CGFloat = (dayMinutes + 0.8) / 1440
            let startAngle = (2 * CGFloat.pi * start) - CGFloat.pi/2
            let endAngle = (2 * CGFloat.pi * end) - CGFloat.pi/2
            
            let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 10, startAngle: startAngle,
                                            endAngle: endAngle, clockwise: true)
            hourLine.path = circularPath.cgPath
            
            if Int(dayMinutes) % 120 == 0 {
                hourLine.strokeColor = UIColor.systemGray.cgColor
            }
            
            layer.addSublayer(hourLine)
            dayMinutes += 60
        }
    }
    
    // User did select timerInterval
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
