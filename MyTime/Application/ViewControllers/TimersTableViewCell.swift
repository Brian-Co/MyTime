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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
