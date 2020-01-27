//
//  StatsTableViewCell.swift
//  MyTime
//
//  Created by Brian Corrieri on 24/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var timerColorView: UIView!
    @IBOutlet weak var timerTotalDuration: UILabel!
    @IBOutlet weak var timerPercentage: UILabel!
    
    var timers: [TimerX] = []
    var timer: TimerX!
    var period: Period!
    var totalDuration = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerColorView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(with timer: TimerX, _ timers: [TimerX], period: Period) {
        
        self.timer = timer
        self.timers = timers
        self.period = period
        
        timerName.text = timer.name
        timerColorView.backgroundColor = TimerColor(rawValue: timer.color)?.create
        
        totalDuration = getTotalDuration(for: timer)
        timerTotalDuration.text = totalDuration.timeString(format: 1)
        
        let percentage = (Double(totalDuration) / Double(getAllTimersTotalDuration())) * 100
        if percentage > 0 {
            timerPercentage.text = "\(Int(percentage))%"
        } else {
            timerPercentage.text = "0%"
        }
    }
    
    
    func getTotalDuration(for timer: TimerX) -> Int {
        
        let totalDuration = timer.timerIntervals.reduce(0, { result, timerInterval in
            
            var totalDuration = result
            
            if !isTimerIntervalWithinPeriod(timerInterval) {
                return totalDuration
            } else {
                
                if let endingPoint = timerInterval.endingPoint {
                    let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                    totalDuration += Int(timerIntervalDuration)
                }
                return totalDuration
            }
        })
        
        return totalDuration
    }
    
    func getAllTimersTotalDuration() -> Int {
        
        var totalDuration = 0
        for timer in timers {
            totalDuration += getTotalDuration(for: timer)
        }
        
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
