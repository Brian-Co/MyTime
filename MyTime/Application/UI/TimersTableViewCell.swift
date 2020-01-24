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
    
    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var timerColorView: UIView!
    @IBOutlet weak var timerTotalDuration: UILabel!
    @IBOutlet weak var timerDuration: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    var saveTimer: UpdateTimerBlock?
    var updateCircleView: UpdateCircleViewBlock?
    var timer: TimerX?
    var totalDuration = 0
    var elapsedTime = 0
    var scheduledTimer = Timer()
    var chosenDate = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerColorView.layer.cornerRadius = 10
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
    }
    
    deinit {
        scheduledTimer.invalidate()
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
        timerColorView.backgroundColor = TimerColor(rawValue: timer.color)?.create
        timerButton.setImage(UIImage(systemName: "timer"), for: .normal)
        elapsedTime = 0
        scheduleTimer()

        if timer.isOn && Calendar.current.isDate(timer.timerIntervals.last!.startingPoint, inSameDayAs: chosenDate) {
            let startingPoint = self.timer?.timerIntervals.last!.startingPoint
            let elapsedTime = Date().timeIntervalSince(startingPoint!)
            self.elapsedTime = Int(elapsedTime)
            timerDuration.text = self.elapsedTime.timeString()
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
        timerColorView.backgroundColor = .systemBackground
        timerDuration.text = ""
        timerTotalDuration.text = ""
        timerButton.backgroundColor = .green
        timerButton.setImage(UIImage(systemName: "plus"), for: .normal)
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
        
        if !(timer?.timerIntervals.isEmpty ?? true) {
            var totalDuration = 0
            for timerInterval in timer!.timerIntervals {
                if let endingPoint = timerInterval.endingPoint, Calendar.current.isDate(timerInterval.startingPoint, inSameDayAs: chosenDate) {
                    let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                    totalDuration += Int(timerIntervalDuration)
                }
            }
            self.totalDuration = totalDuration
            return totalDuration
        }
        return 0
    }
    
    func updateTimer() {
        timerDuration.text = elapsedTime.timeString()
        timerTotalDuration.text = (totalDuration + elapsedTime).timeString(format: 1)
        if elapsedTime % 30 == 0 {
            updateCircleView?()
        }
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        if self.timer != nil {
            timerButtonPressed()
        } else {
            let tableView = self.superview as! UITableView
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            print("lastRowIndex \(lastRowIndex)")
            tableView.selectRow(at: pathToLastRow, animated: true, scrollPosition: .none)
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

