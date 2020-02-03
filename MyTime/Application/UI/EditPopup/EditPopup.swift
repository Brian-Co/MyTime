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
    
    typealias UpdateActiveLayerBlock = ((TimerInterval?, String) -> ())
    
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
    private var updateActiveLayer: UpdateActiveLayerBlock?
    private var refreshCircleView: Block?
    
    let dateFormatter = DateFormatter()
    let tableView = UITableView()
    var dismissFromPopup = Bool()
    
    class func controller(dataSource: EditPopupDataSource, updateActiveLayer: UpdateActiveLayerBlock?, refreshCircleView: Block?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditPopup") as! EditPopup
        controller.dataSource = dataSource
        controller.updateActiveLayer = updateActiveLayer
        controller.refreshCircleView = refreshCircleView
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backgroundView.alpha = 0.4
        let dismissAction = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:)))
        backgroundView.addGestureRecognizer(dismissAction)
        
        popup.layer.cornerRadius = 10
        popupHeaderView.layer.cornerRadius = 10
        
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.cornerRadius = 10
        
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 10
        
        self.definesPresentationContext = true
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "is12HourClock") {
            dateFormatter.dateFormat = "hh:mm a"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        if defaults.integer(forKey: "timeIntervalRounding") == 0 {
            defaults.set(5, forKey: "timeIntervalRounding")
        }
        
        initDataSource()
        configureUI()
        updateUI()
        
        if dataSource.timerInterval.endingPoint == nil {
            deleteButton.setTitle("Cancel", for: .normal)
            configureTableView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        popup.frame = CGRect(x: (self.view.frame.width / 2) - (popup.frame.width / 2), y: (self.view.frame.height / 2) - 55, width: popup.frame.width, height: popup.frame.height)
        tableView.frame = popup.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !dismissFromPopup {
            refreshCircleView?()
        }
    }
    
    func initDataSource() {
        
        dataSource.dismissVC = { [weak self] in self?.dismissPopup() }
        
        if dataSource.timerInterval.endingPoint == nil {
            roundStartingPoint()
        }
    }
    
    func roundStartingPoint() {
        
        let defaults = UserDefaults.standard
        let timeIntervalRounding = defaults.integer(forKey: "timeIntervalRounding")
        
        let startingPoint = dataSource.timerInterval.startingPoint
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startingPoint)
        let minute = calendar.component(.minute, from: startingPoint)
        let floorMinute = minute - (minute % timeIntervalRounding)
        
        dataSource.timerInterval.startingPoint = calendar.date(bySettingHour: hour, minute: floorMinute, second: 0, of: startingPoint)!
    }
    
    @objc func didTapBackground(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissPopup() {
        dismissFromPopup = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteInterval(_ sender: Any) {
        if deleteButton.titleLabel?.text == "Cancel" {
            self.dismiss(animated: true, completion: nil)
        } else {
            dataSource.deleteInterval()
        }
    }
    
    @IBAction func saveInterval(_ sender: Any) {
        let newStartingPointDate = dataSource.timerInterval.startingPoint.addingTimeInterval(startingPointStepper.value * 60)
        let endingPoint = dataSource.timerInterval.endingPoint ?? dataSource.timerInterval.startingPoint
        let newEndingPointDate = endingPoint.addingTimeInterval(endingPointStepper.value * 60)
                
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
    
    func configureUI() {
        
        timerName.text = dataSource.timer?.name ?? "New Timer Interval"
        popupHeaderView.backgroundColor = TimerColor(rawValue: dataSource.timer?.color ?? "orange")?.create
        
        let timeIntervalRounding = UserDefaults.standard.integer(forKey: "timeIntervalRounding")
        startingPointStepper.stepValue = Double(timeIntervalRounding)
        endingPointStepper.stepValue = Double(timeIntervalRounding)
    }
    
    func updateUI() {
        
        let startingPointDate = dataSource.timerInterval.startingPoint.addingTimeInterval(startingPointStepper.value * 60)
        let endingPoint = dataSource.timerInterval.endingPoint ?? dataSource.timerInterval.startingPoint
        let endingPointDate = endingPoint.addingTimeInterval(endingPointStepper.value * 60)
        
        if !endingPointDate.timeIntervalSince(startingPointDate).isLess(than: 0) {
            
            self.startingPoint.text = dateFormatter.string(from: startingPointDate)
            self.endingPoint.text = dateFormatter.string(from: endingPointDate)
            let totalTime = endingPointDate.timeIntervalSince(startingPointDate)
            self.totalTime.text = Int(totalTime).timeString(format: 1)
            self.updateActiveLayer?(TimerInterval(startingPoint: startingPointDate, endingPoint: endingPointDate), dataSource.timer?.color ?? "orange")
        } else {
            startingPointStepper.value = 0
            endingPointStepper.value = 0
        }
    }
    
    func configureTableView() {
                
        tableView.layer.cornerRadius = 10
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        popup.addSubview(tableView)
    }
    
    
}

extension EditPopup: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.timers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Choose timer"
            cell.textLabel?.font = .boldSystemFont(ofSize: 17)
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .secondarySystemBackground
        } else {
            let timer = dataSource.timers[indexPath.row - 1]
            cell.textLabel?.text = timer.name
            cell.textLabel?.textColor = .white
            cell.backgroundColor = TimerColor(rawValue: timer.color)?.create
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            dataSource.timer = dataSource.timers[indexPath.row - 1]
            configureUI()
            updateUI()
            UIView.animate(withDuration: 0.1, animations: {
                tableView.alpha = 0
            })
        }
    }
    
    
}
