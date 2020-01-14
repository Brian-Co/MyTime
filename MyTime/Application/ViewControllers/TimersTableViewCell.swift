//
//  TimersTableViewCell.swift
//  MyTime
//
//  Created by Brian Corrieri on 09/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class TimersTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var timerColorView: UIView!
    @IBOutlet weak var timerTotalDuration: UILabel!
    @IBOutlet weak var timerDuration: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    private var timerHandler: TimerHandler!
    var totalDuration = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerColorView.layer.cornerRadius = 10
        timerButton.layer.cornerRadius = timerButton.frame.width / 2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(timerHandler: TimerHandler) {
        
        self.timerHandler = timerHandler
        self.timerHandler.delegate = self
        self.totalDuration = 0
        
        timerName.text = timerHandler.timerX.name
        timerColorView.backgroundColor = TimerColor(rawValue: timerHandler.timerX.color)?.create
        timerDuration.text = ""
        timerDuration.alpha = 0
        timerButton.backgroundColor = .lightGray
        timerButton.setImage(UIImage(systemName: "timer"), for: .normal)
        
        timerTotalDuration.text = ""
        if !timerHandler.timerX.timerIntervals.isEmpty {
            for timerInterval in timerHandler.timerX.timerIntervals {
                totalDuration += Int(timerInterval.duration)
            }
            timerTotalDuration.text = totalDuration.timeString(format: 1)
        }
        
    }
    
    func setAddTimerCell() {
        
        self.timerHandler = nil
        self.totalDuration = 0
        timerName.text = "Add Timer"
        timerColorView.backgroundColor = .white
        timerDuration.text = ""
        timerTotalDuration.text = ""
        timerButton.backgroundColor = .green
        timerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        if let timerHandler = self.timerHandler {
            timerHandler.timerButtonPressed()
        } else {
            let tableView = self.superview as! UITableView
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            print("lastRowIndex \(lastRowIndex)")
            tableView.selectRow(at: pathToLastRow, animated: true, scrollPosition: .none)
        }
    }
    

}

extension TimersTableViewCell: TimerHandlerDelegate {
    
    func updateTimer(with time: Int) {
        
        timerDuration.text = time.timeString()
        timerTotalDuration.text = (totalDuration + time).timeString(format: 1)
        if timerDuration.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.timerDuration.alpha = 1
            })
        }
    }
    
}
