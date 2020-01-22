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
    @IBOutlet weak var popupHeaderView: UIView!
    @IBOutlet weak var startingPointStepper: UIStepper!
    @IBOutlet weak var endingPointStepper: UIStepper!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var dataSource: EditPopupDataSource!
    
    let dateFormatter = DateFormatter()
    
    class func controller(dataSource: EditPopupDataSource) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditPopup") as! EditPopup
        controller.dataSource = dataSource
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.alpha = 0.4
        let dismissAction = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:)))
        backgroundView.addGestureRecognizer(dismissAction)
        
        popup.layer.cornerRadius = 10
        popupHeaderView.layer.cornerRadius = 10
        popupHeaderView.backgroundColor = TimerColor(rawValue: dataSource.timer.color)?.create
        
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.cornerRadius = 10
        
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 10
        
        self.definesPresentationContext = true
        timerName.text = dataSource.timer.name
        
        dateFormatter.dateFormat = "HH:mm"
        updateUI()
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.dismissVC = { [weak self] in self?.dismissPopup() }
    }
    
    @objc func didTapBackground(_ sender: Any) {
        dismissPopup()
    }
    
    func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteInterval(_ sender: Any) {
        dataSource.deleteInterval()
    }
    
    @IBAction func saveInterval(_ sender: Any) {
        let newStartingPointDate = dataSource.timerInterval.startingPoint.addingTimeInterval(startingPointStepper.value * 60)
        let newEndingPointDate = dataSource.timerInterval.endingPoint!.addingTimeInterval(endingPointStepper.value * 60)
                
        dataSource.timerInterval.startingPoint = newStartingPointDate
        dataSource.timerInterval.endingPoint = newEndingPointDate
                
        dataSource.saveInterval()
    }
    
    
    @IBAction func startingPointStepperTapped(_ sender: Any) {
        updateUI()
    }
    
    @IBAction func endingPointStepperTapped(_ sender: Any) {
        updateUI()
    }
    
    func updateUI() {
        
        let startingPointDate = dataSource.timerInterval.startingPoint.addingTimeInterval(startingPointStepper.value * 60)
        let endingPointDate = dataSource.timerInterval.endingPoint!.addingTimeInterval(endingPointStepper.value * 60)
        
        if !endingPointDate.timeIntervalSince(startingPointDate).isLess(than: 0) {
            
            startingPoint.text = dateFormatter.string(from: startingPointDate)
            endingPoint.text = dateFormatter.string(from: endingPointDate)
            let totalTime = endingPointDate.timeIntervalSince(startingPointDate)
            self.totalTime.text = Int(totalTime).timeString(format: 1)
        } else {
            startingPointStepper.value = 0
            endingPointStepper.value = 0
        }
    }
    
    
}
