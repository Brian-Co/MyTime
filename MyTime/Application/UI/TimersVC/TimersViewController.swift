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
            animateCircleView = true
            updateUI()
        }
    }
    let dateFormatter = DateFormatter()
    let navBarTitle = UILabel()
    var is12HourClock = Bool()
    var animateCircleView = true
    
    var previousDayButton = UIBarButtonItem()
    var nextDayButton = UIBarButtonItem()
    var calendarButton = UIBarButtonItem()
    var settingsButton = UIBarButtonItem()
    
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
        
        dateFormatter.locale = Locale(identifier: "en_EN")
        
        navBarTitle.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        navBarTitle.textColor = .label
        navBarTitle.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        navBarTitle.backgroundColor = UIColor.clear
        navBarTitle.adjustsFontSizeToFitWidth = true
        navBarTitle.textAlignment = .center
        self.navigationItem.titleView = navBarTitle
        
        previousDayButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(getPreviousDay))
        nextDayButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(getNextDay))
        self.navigationItem.leftBarButtonItems  = [previousDayButton, nextDayButton]
        self.navigationItem.leftBarButtonItems![1].isEnabled = false
        
        calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(presentCalendarVC))
        settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(presentSettings))
        self.navigationItem.rightBarButtonItems  = [settingsButton, calendarButton]
        
        timersTableView.delegate = self
        timersTableView.dataSource = self
        timersTableView.separatorColor = UIColor.clear
        
        let editTableViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(editTableView))
        timersTableView.addGestureRecognizer(editTableViewGesture)
        
        dayCircleView.configure(didSelectInterval: { [weak self] timer, timerInterval, sender in
            self?.didSelectInterval(timer, timerInterval, sender) })
        
        initDataSource()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        timersTableView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        is12HourClock = UserDefaults.standard.bool(forKey: "is12HourClock")
        if is12HourClock {
            dateFormatter.dateFormat = "EEEE, MMMM d a"
        } else {
            dateFormatter.dateFormat = "EEEE, MMMM d"
        }

        if !animateCircleView {
            updateUI()
        }
    }
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.stateDidChange = { [weak self] state in self?.dataSourceStateChanged(state) }
        dataSource.fetchData()
    }
    
    func updateUI() {
        
        if !timersTableView.isEditing {
            updateNextDayButton()
        }
        navBarTitle.text = dateFormatter.string(from: chosenDate)
        timersTableView.reloadData()
        dayCircleView.update(with: dataSource.content, chosenDate, animated: animateCircleView)
        animateCircleView = false
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
        if is12HourClock {
            chosenDate = Calendar.current.date(byAdding: .hour, value: -12, to: chosenDate) ?? Date()
        } else {
            chosenDate = Calendar.current.date(byAdding: .day, value: -1, to: chosenDate) ?? Date()
        }
    }
    
    @objc func getNextDay() {
        if is12HourClock {
            chosenDate = Calendar.current.date(byAdding: .hour, value: 12, to: chosenDate) ?? Date()
        } else {
            chosenDate = Calendar.current.date(byAdding: .day, value: 1, to: chosenDate) ?? Date()
        }
    }
    
    func updateNextDayButton() {
        
        let calendar = Calendar.current
        if calendar.isDate(chosenDate, inSameDayAs: Date()) {
            
            let dateHour = calendar.component(.hour, from: Date())
            let choosenDateHour = calendar.component(.hour, from: chosenDate)
            if dateHour < 12 {
                self.navigationItem.leftBarButtonItems![1].isEnabled = false
            } else {
                if choosenDateHour < 12 && is12HourClock {
                    self.navigationItem.leftBarButtonItems![1].isEnabled = true
                } else {
                    self.navigationItem.leftBarButtonItems![1].isEnabled = false
                }
            }
        } else {
            self.navigationItem.leftBarButtonItems![1].isEnabled = true
        }
    }
    
    @objc func presentSettings() {
        didSelectSettings?()
    }
    
    @objc func editTableView() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveTableViewIndexes))
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = [doneButton]
        timersTableView.isEditing = true
    }
    
    @objc func saveTableViewIndexes() {
        
        resetIndexes()
        timersTableView.isEditing = false
        configureNavigationItems()
        dataSource.updateTimerIndexes()
    }
    
    func resetIndexes() {
        
        for timer in dataSource.content {
            let newIndex = dataSource.content.firstIndex{ $0.name == timer.name }
            guard let index = newIndex else { continue }
            dataSource.content[index].index = index
        }
    }
    
    func configureNavigationItems() {
        self.navigationItem.leftBarButtonItems  = [previousDayButton, nextDayButton]
        self.navigationItem.rightBarButtonItems  = [settingsButton, calendarButton]
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != dataSource.content.count {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.row != dataSource.content.count && sourceIndexPath.row != dataSource.content.count {
            let movedTimer = dataSource.content[sourceIndexPath.row]
            dataSource.content.remove(at: sourceIndexPath.row)
            dataSource.content.insert(movedTimer, at: destinationIndexPath.row)
        }
    }
        
}

extension TimersViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func didSelectInterval(_ timer: TimerX?, _ timerInterval: TimerInterval, _ sender: UIView) {
        let editPopup = EditPopup.controller(dataSource: APIEditPopupDataSource(timer: timer, timerInterval: timerInterval), updateActiveLayer: { [weak self] timerInterval, color in
            self?.dayCircleView.updateActiveLayer(with: timerInterval, color)
            }, refreshCircleView: { [weak self] in
                self?.updateUI()
        })
        editPopup.modalPresentationStyle = .popover
        /*
        let popover = editPopup.popoverPresentationController
        editPopup.preferredContentSize = CGSize(width: 200, height: 300)
        popover?.delegate = self
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        */
        self.present(editPopup, animated: true)
    }
    
}
