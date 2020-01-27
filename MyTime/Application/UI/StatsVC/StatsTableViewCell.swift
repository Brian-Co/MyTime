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
    var totalDuration = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerColorView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(with timer: TimerX, _ timers: [TimerX]) {
        
        self.timer = timer
        self.timers = timers
        
        timerName.text = timer.name
        timerColorView.backgroundColor = TimerColor(rawValue: timer.color)?.create
        
        totalDuration = getTotalDuration(for: timer)
        timerTotalDuration.text = totalDuration.timeString(format: 1)
        
        let percentage = (Double(totalDuration) / Double(getAllTimersTotalDuration())) * 100
        timerPercentage.text = "\(Int(percentage))%"
    }
    
    
    func getTotalDuration(for timer: TimerX) -> Int {
        
        let totalDuration = timer.timerIntervals.reduce(0, { result, timerInterval in
            
            var totalDuration = result
            if let endingPoint = timerInterval.endingPoint {
                let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                totalDuration += Int(timerIntervalDuration)
            }
            return totalDuration
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
    
    
}
