//
//  StatsVC.swift
//  MyTime
//
//  Created by Brian Corrieri on 24/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit


enum Period {
    
    case today
    case last7Days
    case last30Days
    case allTime
    case custom
    
}

class StatsVC: UIViewController {
    
    @IBOutlet weak var statsCircleView: StatsCircleView!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var dataSource: StatsDataSource!

    let navBarTitle =  UIButton(type: .custom)
    var didSelectSettings: Block?
    
    var period = Period.last7Days {
        didSet {
            updateUI()
        }
    }
    var firstDate: Date?
    var lastDate: Date?
    
    class func controller(dataSource: StatsDataSource, didSelectSettings: Block?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        controller.dataSource = dataSource
        controller.didSelectSettings = didSelectSettings
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        navBarTitle.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
        navBarTitle.setTitle("Last 7 days ▼", for: .normal)
        navBarTitle.setTitleColor(.systemBlue, for: .normal)
        navBarTitle.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        navigationItem.titleView = navBarTitle
        
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(presentCalendarStatsVC))
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(presentSettings))
        self.navigationItem.rightBarButtonItem  = settingsButton
        self.navigationItem.leftBarButtonItem  = calendarButton
        
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.fetchData()
    }
    
    func updateUI() {
        
        tableView.reloadData()
        statsCircleView.update(with: dataSource.content, period: period, firstDate: firstDate, lastDate: lastDate)
    }
    
    @objc func presentSettings() {
        didSelectSettings?()
    }
    
    @objc func presentCalendarStatsVC() {
        instantiateCalendar()
    }
    
    func instantiateCalendar() {
        let calendarVC = CalendarStatsVC.controller(didSelectDates: { [weak self] firstDate, lastDate in
            self?.didSelectDates(firstDate, lastDate)
        })
        let calendarNavigation = UINavigationController(rootViewController: calendarVC)
        self.present(calendarNavigation, animated: true)
    }
    
    func didSelectDates(_ firstDate: Date?, _ lastDate: Date?) {
        
        if let firstDate = firstDate {
            
            self.firstDate = firstDate
            self.lastDate = lastDate
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            var dateRange = dateformatter.string(from: firstDate)
            if lastDate != nil {
                self.lastDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate!)
                dateRange += " - " + dateformatter.string(from: lastDate!)
            }
            self.navBarTitle.setTitle("\(dateRange) ▼", for: .normal)
            
            self.period = .custom
        } else {
            let period = self.period
            self.period = period
        }
    }
    
    @objc func showActionSheet() {
        
        let alert = UIAlertController(title: "Choose period", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let today = UIAlertAction(title: "Today", style: .default, handler: { alert in
            self.period = .today
            self.navBarTitle.setTitle("Today ▼", for: .normal)
        })
        let last7Days = UIAlertAction(title: "Last 7 days", style: .default, handler: { alert in
            self.period = .last7Days
            self.navBarTitle.setTitle("Last 7 days ▼", for: .normal)
        })
        let last30Days = UIAlertAction(title: "Last 30 days", style: .default, handler: { alert in
            self.period = .last30Days
            self.navBarTitle.setTitle("Last 30 days ▼", for: .normal)
        })
        let allTime = UIAlertAction(title: "All time", style: .default, handler: { alert in
            self.period = .allTime
            self.navBarTitle.setTitle("All time ▼", for: .normal)
        })
        let custom = UIAlertAction(title: "Custom", style: .default, handler: { alert in
            self.instantiateCalendar()
        })
        alert.addAction(cancelAction)
        alert.addAction(today)
        alert.addAction(last7Days)
        alert.addAction(last30Days)
        alert.addAction(allTime)
        alert.addAction(custom)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsTableViewCell
        
        cell.configure(with: dataSource.content[indexPath.row], dataSource.content, period: period, firstDate: firstDate, lastDate: lastDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
