//
//  ViewController.swift
//  MyTime
//
//  Created by Brian Corrieri on 04/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import UIKit

class TimersViewController: UIViewController {
    
    @IBOutlet weak var timersTableView: UITableView!
    
    private var dataSource: TimersDataSource!
    private var coordinator: TimersNavigationCoordinator!
    private var timerHandlers: [TimerHandler] = []
    
    convenience init(dataSource: TimersDataSource) {
        self.init()
        self.dataSource = dataSource
    }
    
    class func controller(dataSource: TimersDataSource, coordinator: TimersNavigationCoordinator) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TimersViewController") as! TimersViewController
        controller.dataSource = dataSource
        controller.coordinator = coordinator
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
        
        if timerHandlers.count != dataSource.content.count {
            timerHandlers = []
            for timer in dataSource.content {
                let timerHandler = TimerHandler(dataSource: dataSource, timer: timer)
                timerHandlers.append(timerHandler)
            }
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
        return dataSource!.content.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimersTableViewCell
        
        if indexPath.row != dataSource.content.count {
            cell.configure(timerHandler: timerHandlers[indexPath.row])
        } else {
            cell.setAddTimerCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator.instantiateEditTimerVC(dataSource: dataSource, timerIndex: indexPath.row)
        print("didSelectRowAt \(indexPath.row)")
    }
    
    
    
}

