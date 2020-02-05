//
//  SettingsVC.swift
//  MyTime
//
//  Created by Brian Corrieri on 28/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UITableViewController {
    
    var dismiss: Block?
    var roundIntervalCellLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 70, height: 20)
        label.textColor = .systemBlue
        return label
    }()
    
    class func controller(dismiss: Block?) -> UITableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        controller.dismiss = dismiss
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: "timeIntervalRounding") == 0 {
            defaults.set(5, forKey: "timeIntervalRounding")
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell = return12HourClockCell(cell)
        } else if indexPath.row == 1 {
            cell = returnRoundTimeIntervalCell(cell)
        } else {
            cell.textLabel?.text = "About"
            let cellImage = UIImage(systemName: "info.circle")
            cell.imageView?.image = cellImage
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            showActionSheet()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func return12HourClockCell(_ cell: UITableViewCell) -> UITableViewCell {
        
        let cellSwitch = UISwitch()
        cellSwitch.isOn = UserDefaults.standard.bool(forKey: "is12HourClock")
        cellSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        let cellImage = UIImage(systemName: "clock")
        cell.imageView?.image = cellImage
        
        cell.textLabel?.text = "12-hour clock"
        cell.accessoryView = cellSwitch
        
        return cell
    }
    
    func returnRoundTimeIntervalCell(_ cell: UITableViewCell) -> UITableViewCell {
        
        cell.textLabel?.text = "Round time interval"
        
        let cellImage = UIImage(systemName: "slider.horizontal.3")
        cell.imageView?.image = cellImage
        
        let timeIntervalRounding = UserDefaults.standard.integer(forKey: "timeIntervalRounding")
        roundIntervalCellLabel.text = "\(timeIntervalRounding) min  ❯"
        cell.accessoryView = roundIntervalCellLabel
        
        return cell
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let defaults = UserDefaults.standard
        let is12HourClock = defaults.bool(forKey: "is12HourClock")
        defaults.set(!is12HourClock, forKey: "is12HourClock")
    }
    
    func showActionSheet() {
        
        let defaults = UserDefaults.standard
        let alert = UIAlertController(title: "Choose time interval", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
        })
        let set5min = UIAlertAction(title: "5 min", style: .default, handler: { alert in
            defaults.set(5, forKey: "timeIntervalRounding")
            self.tableView.reloadData()
        })
        let set10min = UIAlertAction(title: "10 min", style: .default, handler: { alert in
            defaults.set(10, forKey: "timeIntervalRounding")
            self.tableView.reloadData()
        })
        let set15min = UIAlertAction(title: "15 min", style: .default, handler: { alert in
            defaults.set(15, forKey: "timeIntervalRounding")
            self.tableView.reloadData()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(set5min)
        alert.addAction(set10min)
        alert.addAction(set15min)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
