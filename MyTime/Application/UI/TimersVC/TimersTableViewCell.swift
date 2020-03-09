//
//  TimersTableViewCell.swift
//  MyTime
//
//  Created by Brian Corrieri on 09/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class TimersTableViewCell: UITableViewCell {

    typealias UpdateTimerBlock = ((TimerX) -> ())
    typealias UpdateCircleViewBlock = (() -> ())
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var timerColorView: UIView!
    @IBOutlet weak var timerTotalDuration: UILabel!
    @IBOutlet weak var timerDuration: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var addTimerView: UIView!
    
    var saveTimer: UpdateTimerBlock?
    var updateCircleView: UpdateCircleViewBlock?
    var timer: TimerX?
    var totalDuration = 0
    var elapsedTime = 0
    var scheduledTimer = Timer()
    var chosenDate = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellColor()
        timerColorView.layer.cornerRadius = 10
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
        cardView.layer.cornerRadius = 20.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowOpacity = 0.2
    }
    
    deinit {
        scheduledTimer.invalidate()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureCellColor()
    }

    func configureCellColor() {
        if traitCollection.userInterfaceStyle != .dark {
            cardView.backgroundColor = .systemBackground
        } else {
            cardView.backgroundColor = .secondarySystemBackground
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(timer: TimerX, chosenDate: Date, updateTimerBlock: UpdateTimerBlock?, updateCircleViewBlock: UpdateCircleViewBlock?) {
        
        self.timer = timer
        self.chosenDate = chosenDate
        self.saveTimer = updateTimerBlock
        self.updateCircleView = updateCircleViewBlock
        
        timerName.text = timer.name
        timerColorView.isHidden = false
        timerColorView.backgroundColor = TimerColor(rawValue: timer.color)?.create
        timerButton.setImage(UIImage(systemName: "timer"), for: .normal)
        addTimerView.isHidden = true
        elapsedTime = 0
        scheduleTimer()

        if timer.isOn {
            let startingPoint = self.timer?.timerIntervals.last!.startingPoint
            let elapsedTime = Date().timeIntervalSince(startingPoint!)
            timerDuration.text = Int(elapsedTime).timeString()
            if Calendar.current.isDate(timer.timerIntervals.last!.startingPoint, inSameDayAs: chosenDate) {
                self.elapsedTime = Int(elapsedTime)
            }
            timerButton.backgroundColor = timerColorView.backgroundColor
            if timerDuration.alpha == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.timerDuration.alpha = 1
                })
            }
        } else {
            timerDuration.text = ""
            timerDuration.alpha = 0
            timerButton.backgroundColor = .lightGray
        }
        
        totalDuration = getTimerTotalDuration()
        timerTotalDuration.text = (totalDuration + elapsedTime).timeString(format: 1)
    }
    
    func setAddTimerCell() {
        
        self.timer = nil
        timerName.text = "Add Timer"
        timerColorView.isHidden = true
        timerDuration.text = ""
        timerTotalDuration.text = ""
        timerButton.backgroundColor = .green
        timerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTimerView.isHidden = false
    }
    
    func scheduleTimer() {
        
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if self.timer?.isOn ?? false {
                let startingPoint = self.timer?.timerIntervals.last!.startingPoint
                self.elapsedTime = Int(Date().timeIntervalSince(startingPoint!))
                self.updateTimer()
            } else {
                timer.invalidate()
            }
        })
    }
    
    func getTimerTotalDuration() -> Int {
        
        let totalDuration = timer?.timerIntervals.reduce(0, { result, timerInterval in
            
            var totalDuration = result
            if let endingPoint = timerInterval.endingPoint, Calendar.current.isDate(timerInterval.startingPoint, inSameDayAs: chosenDate) {
                let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                totalDuration! += Int(timerIntervalDuration)
            }
            return totalDuration
        })
        
        return totalDuration ?? 0
    }
    
    func updateTimer() {
        timerDuration.text = elapsedTime.timeString()
        if Calendar.current.isDate(chosenDate, inSameDayAs: Date()) {
            timerTotalDuration.text = (totalDuration + elapsedTime).timeString(format: 1)
            if elapsedTime % 30 == 0 {
                updateCircleView?()
            }
        }
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        if self.timer != nil {
            timerButtonPressed()
        }
    }
    
    func timerButtonPressed() {
        
        if timer!.isOn {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        
        let timerInterval = TimerInterval(startingPoint: Date(), endingPoint: nil)
        timer?.timerIntervals.append(timerInterval)
        saveTimer?(self.timer!)
    }
    
    func stopTimer() {
        
        if elapsedTime > 60 {
            var timerIntervalToAppend = timer!.timerIntervals.last!
            timerIntervalToAppend.endingPoint = Date()
            timer!.timerIntervals.removeLast()
            timer!.timerIntervals.append(timerIntervalToAppend)
            saveTimer?(self.timer!)
        } else {
            timer!.timerIntervals.removeLast()
            saveTimer?(self.timer!)
        }
    }
    
}

