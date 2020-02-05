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
    
    typealias DidSelectIntervalBlock = ((_ timer: TimerX?, _ timerInterval: TimerInterval, _ sender: UIView) -> ())
        
    var timers: [TimerX] = [] {
        didSet {
            loadLayers()
        }
    }
    var chosenDate = Date()
    var animate = Bool()
    var is12HourClock = Bool()
    var didSelectInterval: ((_ timer: TimerX?, _ timerInterval: TimerInterval, _ sender: UIView) -> ())?
    
    private var backgroundLayer: CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineWidth = 50
        backgroundLayer.strokeColor = UIColor.quaternarySystemFill.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.frame = bounds
        backgroundLayer.path = circularPath
        
        return backgroundLayer
    }
    
    private var hoursLabels: UILabel {
        let hours = UILabel()
        hours.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        hours.textAlignment = .center
        hours.backgroundColor = UIColor.clear
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
    
    func update(with timers: [TimerX], _ chosenDate: Date, animated: Bool) {
        self.chosenDate = chosenDate
        self.animate = animated
        self.timers = timers
    }
    
    private func loadLayers() {

        is12HourClock = UserDefaults.standard.bool(forKey: "is12HourClock")
        layer.sublayers = nil
        layer.addSublayer(backgroundLayer)
        
        addHoursTextLayers()
        addHoursLines()
        createTimerIntervalsLayers()
    }
    
    private func createTimerIntervalsLayers() {
        
        let calendar = Calendar.current
        var circleMinutes: Double = 1440
        
        for timer in timers {
            for timerInterval in timer.timerIntervals {
                if calendar.isDate(timerInterval.startingPoint, inSameDayAs: chosenDate) {
                    if is12HourClock {
                        circleMinutes = 720
                        let choosenDateHour = calendar.component(.hour, from: chosenDate)
                        let timerIntervalHour = calendar.component(.hour, from: timerInterval.startingPoint)
                        if choosenDateHour >= 0 && choosenDateHour < 12 {
                            if !(0..<12).contains(timerIntervalHour) {
                                continue
                            }
                        } else {
                            if timerIntervalHour < 12 {
                                continue
                            }
                        }
                    }
                    let startAngle = timerInterval.startingPoint.minutesSinceMidnight() / circleMinutes
                    var endAngle: Double = 0
                    var isOn = false
                    if let endingPoint = timerInterval.endingPoint {
                        endAngle = endingPoint.minutesSinceMidnight() / circleMinutes
                    } else {
                        isOn = true
                        endAngle = Date().minutesSinceMidnight() / circleMinutes
                    }
                    createTimerIntervalLayer(startAngle, endAngle, timer.color, isOn)
                }
            }
        }
    }
    
    private func createTimerIntervalLayer(_ startAngle: Double, _ endAngle: Double, _ color: String, _ isOn: Bool, _ isEdited: Bool = false) {
        
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
        if isEdited {
            timerIntervalLayer.setValue(true, forKey: "isEdited")
        }
        
        layer.addSublayer(timerIntervalLayer)
        if animate {
            timerIntervalLayer.strokeEnd = 0
            self.animate(timerIntervalLayer)
        }
    }
    
    func updateActiveLayer(with timerInterval: TimerInterval? = nil, _ color: String = "orange") {
        
        var circleMinutes: Double = 1440
        if is12HourClock {
            circleMinutes = 720
        }
        
        for sublayer in layer.sublayers! {
            if let myLayer = sublayer as? CAShapeLayer {
                if myLayer.value(forKey: "isOn") != nil {
                    updateRunningIntervalLayer(myLayer, circleMinutes)
                } else if myLayer.value(forKey: "isEdited") != nil {
                    if let timerInterval = timerInterval {
                        updateExistingIntervalLayer(myLayer, timerInterval, color, circleMinutes)
                    }
                }
            }
        }
    }
    
    func updateRunningIntervalLayer(_ runningLayer: CAShapeLayer, _ circleMinutes: Double) {
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let startAngle = runningLayer.value(forKey: "startAngle") as! CGFloat - CGFloat.pi/2
        let newAngle = Date().minutesSinceMidnight() / circleMinutes
        let endAngle = (2 * CGFloat.pi * CGFloat(newAngle)) - CGFloat.pi/2
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: startAngle,
                                        endAngle: endAngle, clockwise: true)
        runningLayer.path = circularPath.cgPath
    }
    
    func updateExistingIntervalLayer(_ existingLayer: CAShapeLayer, _ timerInterval: TimerInterval, _ color: String, _ circleMinutes: Double) {
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let newStartAngle = timerInterval.startingPoint.minutesSinceMidnight() / circleMinutes
        let startAngle = (2 * CGFloat.pi * CGFloat(newStartAngle)) - CGFloat.pi/2
        var newEndAngle = timerInterval.endingPoint!.minutesSinceMidnight() / circleMinutes
        if newEndAngle == newStartAngle {
            newEndAngle = newEndAngle + 0.001
        }
        let endAngle = (2 * CGFloat.pi * CGFloat(newEndAngle)) - CGFloat.pi/2
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: startAngle,
                                        endAngle: endAngle, clockwise: true)
        existingLayer.strokeColor = TimerColor(rawValue: color)?.create.cgColor
        let oldPath = existingLayer.path!
        existingLayer.path = circularPath.cgPath
        animatePath(existingLayer, oldPath)
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
                if var startAngle = sublayer.value(forKey: "startAngle") as? CGFloat, var endAngle = sublayer.value(forKey: "endAngle") as? CGFloat {
                    if startAngle > (2 * CGFloat.pi) {
                        startAngle = startAngle - (2 * CGFloat.pi)
                    }
                    if endAngle > (2 * CGFloat.pi) {
                        endAngle = endAngle - (2 * CGFloat.pi)
                    }
                    if startAngle > endAngle {
                        if (startAngle...(2 * CGFloat.pi)).contains(pointAngle) || (0...endAngle).contains(pointAngle) {
                            let startAnglePercent = startAngle / (2 * CGFloat.pi)
                            let endAnglePercent = endAngle / (2 * CGFloat.pi)
                            didSelectInterval = true
                            sublayer.setValue(true, forKey: "isEdited")
                            findTimerFrom(Double(startAnglePercent), Double(endAnglePercent))
                        }
                    } else if (startAngle...endAngle).contains(pointAngle) {
                        let startAnglePercent = startAngle / (2 * CGFloat.pi)
                        let endAnglePercent = endAngle / (2 * CGFloat.pi)
                        didSelectInterval = true
                        sublayer.setValue(true, forKey: "isEdited")
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
        
    /// User did select a timerIntervalLayer. This methods looks for the TimerInterval instance that matches the selected timerIntervalLayer, and tells the delegate when it succeeds.
    func findTimerFrom(_ startAngle: Double, _ endAngle: Double) {
        
        var circleMinutes: Double = 1440
        if is12HourClock {
            circleMinutes = 720
        }

        let startingPointMinutes = String(format: "%.6f", startAngle * circleMinutes)
        let endingPointMinutes = String(format: "%.6f", endAngle * circleMinutes)
        
        for timer in timers {
            for timerInterval in timer.timerIntervals {
                if let endingPoint = timerInterval.endingPoint {
                    
                    var isStartingPointAfternoon: Double = 0
                    var isEndingPointAfternoon: Double = 0
                    
                    if is12HourClock {
                        let startingPointHour = Calendar.current.component(.hour, from: timerInterval.startingPoint)
                        if startingPointHour >= 12 {
                            isStartingPointAfternoon = 720
                        }
                        let endingPointHour = Calendar.current.component(.hour, from: endingPoint)
                        if endingPointHour >= 12 {
                            isEndingPointAfternoon = 720
                        }
                    }
                    
                    let minutesStartingPoint = String(format: "%.6f", timerInterval.startingPoint.minutesSinceMidnight() - isStartingPointAfternoon)
                    let minutesEndingPoint = String(format: "%.6f", endingPoint.minutesSinceMidnight() - isEndingPointAfternoon)
                    
                    if minutesStartingPoint == startingPointMinutes && minutesEndingPoint == endingPointMinutes {
                        didSelectInterval?(timer, timerInterval, self)
                    }
                }
            }
        }
    }
    
    ///User did select an empty space on the circle. This method creates a timerIntervalLayer and a new TimerInterval instance based on where the user tapped, and sends it to the delegate.
    func createTimerIntervalFrom(_ angle: Double) {
        
        var circleMinutes: Double = 1440
        if is12HourClock {
            circleMinutes = 720
        }
        
        let startingPointMinutes = angle * circleMinutes
        var hours = Int(startingPointMinutes / 60)
        let minutes = Int(startingPointMinutes) % 60
        
        if is12HourClock && Calendar.current.component(.hour, from: chosenDate) >= 12 {
            hours += 12
        }
        
        let date = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: chosenDate)!
        
        let newInterval = TimerInterval(startingPoint: date, endingPoint: nil)
        
        createTimerIntervalLayer(angle, angle, "orange", false, true)
        
        didSelectInterval?(nil, newInterval, self)
    }
    
}


///UI methods to configure the view
extension DayCircleView {
    
    private func addHoursTextLayers() {
        
        var hours = ["24", "6", "12", "18"]
        if is12HourClock {
            hours = ["12", "3", "6", "9"]
        }
        
        let hours24 = hoursLabels
        hours24.frame = CGRect(x: bounds.width / 2 - 10, y: 40, width: 20, height: 60)
        hours24.text = hours[0]
        addSubview(hours24)
        
        let hours6 = hoursLabels
        hours6.frame = CGRect(x: bounds.width - 100, y: bounds.height / 2 - 10, width: 60, height: 20)
        hours6.text = hours[1]
        addSubview(hours6)
        
        let hours12 = hoursLabels
        hours12.frame = CGRect(x: bounds.width / 2 - 10, y: bounds.height - 100, width: 20, height: 60)
        hours12.text = hours[2]
        addSubview(hours12)
        
        let hours18 = hoursLabels
        hours18.frame = CGRect(x: 40, y: bounds.height / 2 - 10, width: 60, height: 20)
        hours18.text = hours[3]
        addSubview(hours18)
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
    
    
}

///Layers animations
extension DayCircleView {
    
    private func animate(_ layer: CAShapeLayer) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            layer.strokeEnd = 1
        })
        let foregroundAnimation = CABasicAnimation(keyPath: "strokeEnd")
        foregroundAnimation.fromValue = 0
        foregroundAnimation.toValue = 1
        foregroundAnimation.beginTime = CACurrentMediaTime() + 0.3
        foregroundAnimation.duration = CFTimeInterval(0.5)
        foregroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        foregroundAnimation.fillMode = CAMediaTimingFillMode.forwards
        foregroundAnimation.isRemovedOnCompletion = false
        
        layer.add(foregroundAnimation, forKey: "foregroundAnimation")
        CATransaction.commit()
    }
    
    private func animatePath(_ layer: CAShapeLayer, _ oldPath: CGPath) {
        let foregroundAnimation = CABasicAnimation(keyPath: "path")
        foregroundAnimation.fromValue = oldPath
        foregroundAnimation.toValue = layer.path
        foregroundAnimation.duration = CFTimeInterval(0.2)
        foregroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        foregroundAnimation.fillMode = CAMediaTimingFillMode.forwards
        foregroundAnimation.isRemovedOnCompletion = false
        
        layer.add(foregroundAnimation, forKey: "foregroundAnimation")
    }
    
}
