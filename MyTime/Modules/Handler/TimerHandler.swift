//
//  TimerHandler.swift
//  MyTime
//
//  Created by Brian Corrieri on 10/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation


class TimerHandler {
    
    weak var delegate: TimerHandlerDelegate?
    private var dataSource: TimersDataSource!
    var timerX: TimerX
    
    var timerInterval: TimerInterval?
    var timerIsOn = false
    var seconds = 0
    var timer = Timer()
    
    init(dataSource: TimersDataSource, timer: TimerX) {
        self.dataSource = dataSource
        self.timerX = timer
    }
    
    deinit {
        timer.invalidate()
    }
    
    func timerButtonPressed() {

        if timerIsOn {
            timerIsOn = false
            stopTimer()
        } else {
            timerIsOn = true
            startTimer()
        }
    }
    
    func startTimer() {

        if seconds != 0 {
            seconds = 0
        }
        
        timerInterval = TimerInterval(startingPoint: Date(), duration: TimeInterval(seconds))
        
        delegate?.updateTimer(with: seconds.timeString())
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            
            if self.timerIsOn {
                self.updateTimer()
            } else {
                timer.invalidate()
            }
        })
    }
    
    func updateTimer() {
        seconds += 1
        delegate?.updateTimer(with: seconds.timeString())
    }
    
    func stopTimer() {
        timerInterval?.duration = TimeInterval(seconds)
        timerX.timerIntervals.append(timerInterval!)
        dataSource.updateTimer(timerX)
    }
    
    
}
