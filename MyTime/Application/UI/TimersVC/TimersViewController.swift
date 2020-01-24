//
//  ViewController.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class TimersViewController: UIViewController {
    
    typealias DidSelectTimerBlock = ((_ timer: TimerX?) -> ())
    typealias DidSelectIntervalBlock = ((_ timer: TimerX?, _ timerInterval: TimerInterval) -> ())
    typealias DidSelectStatsBlock = (() -> ())
    
    @IBOutlet weak var timersTableView: UITableView!
    @IBOutlet weak var dayCircleView: DayCircleView!
    
    private var dataSource: TimersDataSource!
    private var didSelectTimer: DidSelectTimerBlock?
    private var didSelectInterval: DidSelectIntervalBlock?
    private var didSelectStats: DidSelectStatsBlock?
    
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
    
    class func controller(dataSource: TimersDataSource, didSelectTimer: DidSelectTimerBlock?, didSelectInterval: DidSelectIntervalBlock?, didSelectStatsBlock: DidSelectStatsBlock?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TimersViewController") as! TimersViewController
        controller.dataSource = dataSource
        controller.didSelectTimer = didSelectTimer
        controller.didSelectInterval = didSelectInterval
        controller.didSelectStats = didSelectStatsBlock
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
        
        let statsButton = UIBarButtonItem(image: UIImage(systemName: "chart.pie"), style: .plain, target: self, action: #selector(presentStatsVC))
        self.navigationItem.rightBarButtonItem  = statsButton
        
        timersTableView.delegate = self
        timersTableView.dataSource = self
        
        dayCircleView.configure(didSelectInterval: didSelectInterval)
        
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.stateDidChange = { [weak self] state in self?.dataSourceStateChanged(state) }
        dataSource.fetchData()
    }
    
    func updateUI() {
        
        self.navigationItem.title = dateFormatter.string(from: chosenDate)
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
    
    @objc func getPreviousDay() {
        chosenDate = Calendar.current.date(byAdding: .day, value: -1, to: chosenDate) ?? Date()
    }
    
    @objc func getNextDay() {
        chosenDate = Calendar.current.date(byAdding: .day, value: 1, to: chosenDate) ?? Date()
    }
    
    @objc func presentStatsVC() {
        didSelectStats?()
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

