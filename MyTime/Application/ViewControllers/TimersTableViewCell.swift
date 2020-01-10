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
    
    var timer: Timer?
    private var timerHandler: TimerHandler!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerColorView.layer.cornerRadius = 10
        timerButton.layer.cornerRadius = timerButton.frame.width / 2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(dataSource: TimersDataSource) {
        
        timerHandler = TimerHandler(delegate: self, dataSource: dataSource)
        timerName.text = timer?.name
        timerColorView.backgroundColor = TimerColor(rawValue: "orange")?.create
        timerDuration.text = ""
        timerTotalDuration.text = ""
        
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        timerHandler.timerButtonPressed()
    }
    

}

extension TimersTableViewCell: TimerHandlerDelegate {
    
    
    func updateTimer() {
        
    }
    
    func timerDidStop() {
        
    }
    
    
}
