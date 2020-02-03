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
    case yesterday
    case last7Days
    case last30Days
    case allTime
    
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
        
        navBarTitle.frame = CGRect(x: 0, y: 0, width: 130, height: 40)
        navBarTitle.setTitle("Last 7 days ▼", for: .normal)
        navBarTitle.setTitleColor(.systemBlue, for: .normal)
        navBarTitle.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        navigationItem.titleView = navBarTitle
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(presentSettings))
        self.navigationItem.rightBarButtonItem  = settingsButton
        
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.fetchData()
    }
    
    func updateUI() {
        
        tableView.reloadData()
        statsCircleView.update(with: dataSource.content, period: period)
    }
    
    @objc func presentSettings() {
        didSelectSettings?()
    }
    
    @objc func showActionSheet() {
        
        let alert = UIAlertController(title: "Choose period", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let today = UIAlertAction(title: "Today", style: .default, handler: { alert in
            self.period = .today
            self.navBarTitle.setTitle("Today ▼", for: .normal)
        })
        let yesterday = UIAlertAction(title: "Yesterday", style: .default, handler: { alert in
            self.period = .yesterday
            self.navBarTitle.setTitle("Yesterday ▼", for: .normal)
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
        alert.addAction(cancelAction)
        alert.addAction(today)
        alert.addAction(yesterday)
        alert.addAction(last7Days)
        alert.addAction(last30Days)
        alert.addAction(allTime)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsTableViewCell
        
        cell.configure(with: dataSource.content[indexPath.row], dataSource.content, period: period)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
