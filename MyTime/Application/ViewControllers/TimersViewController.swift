//
//  ViewController.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class TimersViewController: UIViewController {
    
    typealias DidSelectTimerBlock = ((_ timer: TimerX) -> ())
    
    @IBOutlet weak var timersTableView: UITableView!
    
    private var dataSource: TimersDataSource!
    private var timerHandlers: [TimerHandler] = []
    private var didSelectTimer: DidSelectTimerBlock?
    
    convenience init(dataSource: TimersDataSource) {
        self.init()
        self.dataSource = dataSource
    }
    
    class func controller(dataSource: TimersDataSource, didSelectTimer: DidSelectTimerBlock?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TimersViewController") as! TimersViewController
        controller.dataSource = dataSource
        controller.didSelectTimer = didSelectTimer
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
        self.navigationItem.title = dateFormatter.string(from: date)
        
        timersTableView.delegate = self
        timersTableView.dataSource = self
        
        initDataSource()
        
    }
    
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.stateDidChange = { [weak self] state in self?.dataSourceStateChanged(state) }
        dataSource.fetchData()
        
    }
    
    
    func updateUI() {
        
        timerHandlers = []
        for timer in dataSource.content {
            let timerHandler = TimerHandler(dataSource: dataSource, timer: timer)
            timerHandlers.append(timerHandler)
        }
        
        timersTableView.reloadData()
    }
    
    func dataSourceStateChanged(_ state: DataSourceState) {
        
        switch state {
        case .noData:
            break
        default:
            break
        }
    }
    
    
}


extension TimersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerHandlers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimersTableViewCell
        
        let timer = dataSource.content[indexPath.row]
        if indexPath.row != timerHandlers.count {
            cell.configure(timerHandler: timerHandlers[indexPath.row])
        } else {
            cell.setAddTimerCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectTimer?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            timerHandlers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            dataSource.deleteTimer(dataSource.content[indexPath.row])
        }
    }
    
    
}

