//
//  TodayViewController.swift
//  MyTime Today Extension
//
//  Created by Brian Corrieri on 27/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var timerColorView: UIView!
    @IBOutlet weak var timerTotalDuration: UILabel!
    @IBOutlet weak var timerDuration: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    var dataSource: TodayDataSource!
    
    var timer: TimerX!
    var scheduledTimer = Timer()
    var elapsedTime = 0
    var totalDuration = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerColorView.layer.cornerRadius = 10
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
        
        let openApp = UITapGestureRecognizer(target: self, action: #selector(openMainApp))
        view.addGestureRecognizer(openApp)
        
        initDataSource()
    }
    
    @objc func openMainApp() {
        extensionContext?.open(URL(string: "mytime://")!, completionHandler: nil)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func initDataSource() {
        
        dataSource = APITodayDataSource() { [weak self] timer in
            self?.updateUI(with: timer)
        }
    }
    
    func updateUI(with timer: TimerX) {
        
        self.timer = timer
        timerName.text = timer.name
        
        if timer.index >= 0 {
            
            timerButton.isHidden = false
            timerButton.setImage(UIImage(systemName: "timer"), for: .normal)
            timerColorView.isHidden = false
            timerColorView.backgroundColor = TimerColor(rawValue: timer.color)?.create
            timerTotalDuration.textColor = .white
            scheduleTimer()
            
            if timer.isOn {
                let startingPoint = timer.timerIntervals.last!.startingPoint
                let elapsedTime = Date().timeIntervalSince(startingPoint)
                timerDuration.text = Int(elapsedTime).timeString()
                if Calendar.current.isDate(startingPoint, inSameDayAs: Date()) {
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
            
            totalDuration = getTotalDuration()
            timerTotalDuration.text = (totalDuration + elapsedTime).timeString(format: 1)
        } else {
            timerColorView.isHidden = true
            timerButton.setImage(UIImage(systemName: "plus"), for: .normal)
            timerButton.backgroundColor = .green
            timerDuration.text = ""
            timerDuration.alpha = 0
        }
    }
    
    func scheduleTimer() {
        
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { scheduledTimer in
            if self.timer.isOn {
                let startingPoint = self.timer.timerIntervals.last!.startingPoint
                self.elapsedTime = Int(Date().timeIntervalSince(startingPoint))
                self.updateTimer()
            } else {
                scheduledTimer.invalidate()
            }
        })
    }
    
    func updateTimer() {
        timerDuration.text = elapsedTime.timeString()
        timerTotalDuration.text = (totalDuration + elapsedTime).timeString(format: 1)
    }
    
    func getTotalDuration() -> Int {
        
        let totalDuration = timer.timerIntervals.reduce(0, { result, timerInterval in
            
            var totalDuration = result
            if let endingPoint = timerInterval.endingPoint, Calendar.current.isDate(timerInterval.startingPoint, inSameDayAs: Date()) {
                let timerIntervalDuration = endingPoint.timeIntervalSince(timerInterval.startingPoint)
                totalDuration += Int(timerIntervalDuration)
            }
            return totalDuration
        })
        
        return totalDuration
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        
        if timer.index >= 0 {
            timerButtonPressed()
        } else {
            openMainApp()
        }
    }
    
    func timerButtonPressed() {
        
        if timer.isOn {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        
        let timerInterval = TimerInterval(startingPoint: Date(), endingPoint: nil)
        timer.timerIntervals.append(timerInterval)
        dataSource.update(timer)
    }
    
    func stopTimer() {
        
        if elapsedTime > 60 {
            var timerIntervalToAppend = timer.timerIntervals.last!
            timerIntervalToAppend.endingPoint = Date()
            timer.timerIntervals.removeLast()
            timer.timerIntervals.append(timerIntervalToAppend)
            dataSource.update(timer)
        } else {
            timer.timerIntervals.removeLast()
            dataSource.update(timer)
        }
    }
    
    
}
