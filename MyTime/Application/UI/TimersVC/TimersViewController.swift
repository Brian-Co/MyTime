//
//  ViewController.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

typealias Block = (() -> ())

class TimersViewController: UIViewController {
    
    typealias DidSelectTimerBlock = ((_ timer: TimerX?) -> ())
    
    @IBOutlet weak var timersTableView: UITableView!
    @IBOutlet weak var dayCircleView: DayCircleView!
    
    private var dataSource: TimersDataSource!
    private var didSelectTimer: DidSelectTimerBlock?
    private var didSelectSettings: Block?
    
    var chosenDate = Date() {
        didSet {
            updateUI()
        }
    }
    let dateFormatter = DateFormatter()
    
    convenience init(dataSource: TimersDataSource) {
        self.init()
        self.dataSource = dataSource
    }
    
    class func controller(dataSource: TimersDataSource, didSelectTimer: DidSelectTimerBlock?, didSelectSettings: Block?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TimersViewController") as! TimersViewController
        controller.dataSource = dataSource
        controller.didSelectTimer = didSelectTimer
        controller.didSelectSettings = didSelectSettings
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
        
        let previousDayButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(getPreviousDay))
        let nextDayButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(getNextDay))
        self.navigationItem.leftBarButtonItems  = [previousDayButton, nextDayButton]
        self.navigationItem.leftBarButtonItems![1].isEnabled = false
        
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(presentCalendarVC))
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(presentSettings))
        self.navigationItem.rightBarButtonItems  = [settingsButton, calendarButton]
        
        timersTableView.delegate = self
        timersTableView.dataSource = self
        
        dayCircleView.configure(didSelectInterval: { [weak self] timer, timerInterval, sender in
            self?.didSelectInterval(timer, timerInterval, sender) })
        
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.stateDidChange = { [weak self] state in self?.dataSourceStateChanged(state) }
        dataSource.fetchData()
    }
    
    func updateUI() {
        
        self.navigationItem.title = dateFormatter.string(from: chosenDate)
        updateNextDayButton()
        timersTableView.reloadData()
        dayCircleView.update(with: dataSource.content, chosenDate)
    }
    
    func dataSourceStateChanged(_ state: DataSourceState) {
        
        switch state {
        case .noData:
            break
        default:
            break
        }
    }
    
    @objc func presentCalendarVC() {
        let calendarVC = CalendarVC.controller(didSelectDate: { [weak self] date in
            self?.didSelectDate(date)
        })
        let calendarNavigation = UINavigationController(rootViewController: calendarVC)
        self.present(calendarNavigation, animated: true)
    }
    
    func didSelectDate(_ date: Date) {
        chosenDate = date
    }
    
    @objc func getPreviousDay() {
        chosenDate = Calendar.current.date(byAdding: .day, value: -1, to: chosenDate) ?? Date()
    }
    
    @objc func getNextDay() {
        chosenDate = Calendar.current.date(byAdding: .day, value: 1, to: chosenDate) ?? Date()
    }
    
    func updateNextDayButton() {
        if Calendar.current.isDate(chosenDate, inSameDayAs: Date()) {
            self.navigationItem.leftBarButtonItems![1].isEnabled = false
        } else {
            self.navigationItem.leftBarButtonItems![1].isEnabled = true
        }
    }
    
    @objc func presentSettings() {
        didSelectSettings?()
    }
    
}


extension TimersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.content.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimersTableViewCell
        
        if indexPath.row != dataSource.content.count {
            cell.configure(timer: dataSource.content[indexPath.row], chosenDate: chosenDate, updateTimerBlock: { [weak self] timer in
                self?.dataSource.updateTimer(timer)
                }, updateCircleViewBlock: { [weak self] in
                self?.dayCircleView.updateActiveLayer()
            })
        } else {
            cell.setAddTimerCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != dataSource.content.count {
            didSelectTimer?(dataSource.content[indexPath.row])
        } else {
            didSelectTimer?(nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteTimer(at: indexPath)
        }
    }
    
    func deleteTimer(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "All data associated with this timer will be lost.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { alert in
            let timerName = self.dataSource.content[indexPath.row].name
            self.dataSource.content.remove(at: indexPath.row)
            self.timersTableView.deleteRows(at: [indexPath], with: .left)
            self.dataSource.deleteTimer(timerName)
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension TimersViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func didSelectInterval(_ timer: TimerX?, _ timerInterval: TimerInterval, _ sender: UIView) {
        let editPopup = EditPopup.controller(dataSource: APIEditPopupDataSource(timer: timer, timerInterval: timerInterval))
        editPopup.modalPresentationStyle = .popover
        let popover = editPopup.popoverPresentationController
        editPopup.preferredContentSize = CGSize(width: 200, height: 300)
        popover?.delegate = self
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        
        self.present(editPopup, animated: true)
    }
    
}
