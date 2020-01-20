//
//  EditPopup.swift
//  MyTime
//
//  Created by Brian Corrieri on 20/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit


class EditPopup: UIViewController {
    
    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var startingPoint: UILabel!
    @IBOutlet weak var endingPoint: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    
    var timer: TimerX!
    var timerInterval: TimerInterval!
    
    class func controller(timer: TimerX, timerInterval: TimerInterval) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditPopup") as! EditPopup
        controller.timer = timer
        controller.timerInterval = timerInterval
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.alpha = 0.4
        let dismissAction = UITapGestureRecognizer(target: self, action: #selector(dismissPopup(_:)))
        backgroundView.addGestureRecognizer(dismissAction)
        
        popup.layer.cornerRadius = 10
        
        self.definesPresentationContext = true
        timerName.text = timer.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startingPoint.text = dateFormatter.string(from: timerInterval.startingPoint)
        endingPoint.text = dateFormatter.string(from: timerInterval.endingPoint!)
        
        let totalTime = timerInterval.endingPoint!.timeIntervalSince(timerInterval.startingPoint)
        self.totalTime.text = Int(totalTime).timeString(format: 1)
        
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
