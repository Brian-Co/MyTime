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
    
    private var dataSource: TimersCellDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = APITimersCellDataSource()
        initDataSource()
        timerColorView.layer.cornerRadius = 10
        timerButton.layer.cornerRadius = timerButton.frame.width / 2
    }
    
    func initDataSource() {
        
        dataSource.updateTimer = { [weak self] time in self?.updateTimer(with: time) }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(timer: TimerX) {
        
        dataSource.timer = timer
        
        timerName.text = timer.name
        timerColorView.backgroundColor = TimerColor(rawValue: timer.color)?.create
        timerDuration.text = ""
        timerDuration.alpha = 0
        timerButton.backgroundColor = .lightGray
        timerButton.setImage(UIImage(systemName: "timer"), for: .normal)
        
        let totalDuration = dataSource.getTimerTotalDuration()
        timerTotalDuration.text = totalDuration.timeString(format: 1)
    }
    
    func setAddTimerCell() {
        
        dataSource.timer = nil
        timerName.text = "Add Timer"
        timerColorView.backgroundColor = .systemBackground
        timerDuration.text = ""
        timerTotalDuration.text = ""
        timerButton.backgroundColor = .green
        timerButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    func updateTimer(with time: Int) {
        
        timerDuration.text = time.timeString()
        timerTotalDuration.text = (dataSource.timerTotalDuration + time).timeString(format: 1)
        if timerDuration.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.timerDuration.alpha = 1
            })
        }
        timerButton.backgroundColor = timerColorView.backgroundColor
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        if dataSource.timer != nil {
            dataSource.timerButtonPressed()
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

