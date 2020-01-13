//
//  EditTimerVC.swift
//  MyTime
//
//  Created by Brian Corrieri on 13/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit

class EditTimerVC: UIViewController {
    
    @IBOutlet weak var timerName: UILabel!
    
    private var dataSource: TimersDataSource!
    private var coordinator: Coordinator!
    private var timerIndex: Int = 0
    
    class func controller(dataSource: TimersDataSource, coordinator: Coordinator, timerIndex: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditTimerVC") as! EditTimerVC
        controller.dataSource = dataSource
        controller.coordinator = coordinator
        controller.timerIndex = timerIndex
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if timerIndex != dataSource.content.count {
            timerName.text = dataSource.content[timerIndex].name
        } else {
            timerName.text = "New Timer"
        }
        
    }
    
    
}
