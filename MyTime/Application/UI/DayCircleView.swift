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
    
    private var dataSource: DayCircleViewDataSource!
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineWidth = 50
        backgroundLayer.strokeColor = UIColor.secondarySystemBackground.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.frame = bounds
        backgroundLayer.path = circularPath
        
        return backgroundLayer
    }()
        
    private var circularPath: CGPath {
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: -CGFloat.pi/2,
        endAngle: (2 * CGFloat.pi) - CGFloat.pi/2, clockwise: true)
        return circularPath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = APIDayCircleViewDataSource()
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.loadLayers = { [weak self] in self?.loadLayers() }
        dataSource.createTimerIntervalLayer = { [weak self] startAngle, endAngle, color in self?.createTimerIntervalLayer(startAngle: startAngle, endAngle: endAngle, color: color) }
    }
    
    func updateDataSource(with timers: [TimerX]) {
        dataSource.timers = timers
    }
    
    private func loadLayers() {
        
        layer.sublayers = nil
        layer.addSublayer(backgroundLayer)
    }
    
    private func createTimerIntervalLayer(startAngle: Double, endAngle: Double, color: String) {
        
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
        
        layer.addSublayer(timerIntervalLayer)
    }
    
}
