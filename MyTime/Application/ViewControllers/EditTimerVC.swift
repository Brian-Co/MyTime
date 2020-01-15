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
    
    @IBOutlet weak var timerName: UITextField!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var tealButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var timerColor: TimerColor?
    
    private var dataSource: TimersDataSource!
    private var coordinator: Coordinator!
    private var timerIndex: Int = 0
    private var editTimerHandler: EditTimerHandler?
    private var dismissBlock: (() -> ())?
    
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
        
        timerName.delegate = self
        configureUI()
        
    }
    
    @objc func isDoneEditing() {
        let color = timerColor?.rawValue
        editTimerHandler?.isDoneEditingTimer(timerName: timerName.text!, timerColor: color)
    }
    
    func configureUI() {
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(isDoneEditing))
        self.navigationItem.rightBarButtonItem  = doneButton
        
        if timerIndex != dataSource.content.count {
            self.editTimerHandler = EditTimerHandler(dataSource: dataSource, delegate: self, timer: dataSource.content[timerIndex])
            self.navigationItem.title = "Edit Timer"
            timerName.text = dataSource.content[timerIndex].name
            timerColor = TimerColor(rawValue: dataSource.content[timerIndex].color)
            switchTimerColor()
        } else {
            self.editTimerHandler = EditTimerHandler(dataSource: dataSource, delegate: self, timer: nil)
            self.navigationItem.title = "New Timer"
            self.deleteButton.isHidden = true
        }
        
        configureButtonsUI()
    }
    
    func configureButtonsUI() {
        
        orangeButton.layer.cornerRadius = 10
        tealButton.layer.cornerRadius = 10
        purpleButton.layer.cornerRadius = 10
        brownButton.layer.cornerRadius = 10
        greenButton.layer.cornerRadius = 10
        yellowButton.layer.cornerRadius = 10
        redButton.layer.cornerRadius = 10
        blueButton.layer.cornerRadius = 10
        
        orangeButton.layer.borderColor = UIColor.gray.cgColor
        tealButton.layer.borderColor = UIColor.gray.cgColor
        purpleButton.layer.borderColor = UIColor.gray.cgColor
        brownButton.layer.borderColor = UIColor.gray.cgColor
        greenButton.layer.borderColor = UIColor.gray.cgColor
        yellowButton.layer.borderColor = UIColor.gray.cgColor
        redButton.layer.borderColor = UIColor.gray.cgColor
        blueButton.layer.borderColor = UIColor.gray.cgColor
        
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "All data associated with this timer will be lost.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { alert in
            self.dataSource.deleteTimer(self.dataSource.content[self.timerIndex])
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func orangeButtonPressed(_ sender: Any) {
        timerColor = .orange
        switchTimerColor()
    }
    
    @IBAction func tealButtonPressed(_ sender: Any) {
        timerColor = .teal
        switchTimerColor()
    }
    
    @IBAction func purpleButtonPressed(_ sender: Any) {
        timerColor = .purple
        switchTimerColor()
    }
    
    @IBAction func brownButtonPressed(_ sender: Any) {
        timerColor = .brown
        switchTimerColor()
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        timerColor = .green
        switchTimerColor()
    }
    
    @IBAction func yellowButtonPressed(_ sender: Any) {
        timerColor = .yellow
        switchTimerColor()
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        timerColor = .red
        switchTimerColor()
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        timerColor = .blue
        switchTimerColor()
    }
    
    func switchTimerColor() {
        
        orangeButton.layer.borderWidth = 0
        tealButton.layer.borderWidth = 0
        purpleButton.layer.borderWidth = 0
        brownButton.layer.borderWidth = 0
        greenButton.layer.borderWidth = 0
        yellowButton.layer.borderWidth = 0
        redButton.layer.borderWidth = 0
        blueButton.layer.borderWidth = 0
        
        switch timerColor {
        case .orange:
            orangeButton.layer.borderWidth = 3
        case .teal:
            tealButton.layer.borderWidth = 3
        case .purple:
            purpleButton.layer.borderWidth = 3
        case .brown:
            brownButton.layer.borderWidth = 3
        case .green:
            greenButton.layer.borderWidth = 3
        case .yellow:
            yellowButton.layer.borderWidth = 3
        case .red:
            redButton.layer.borderWidth = 3
        case .blue:
            blueButton.layer.borderWidth = 3
        case .none:
            break
        }
        
    }
    
    
}

extension EditTimerVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension EditTimerVC: EditTimerHandlerDelegate {
        
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
