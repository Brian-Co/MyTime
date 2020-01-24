//
//  StatsVC.swift
//  MyTime
//
//  Created by Brian Corrieri on 24/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit


class StatsVC: UIViewController {
    
    @IBOutlet weak var statsCircleView: StatsCircleView!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var dataSource: StatsDataSource!

    
    class func controller(dataSource: StatsDataSource) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        controller.dataSource = dataSource
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initDataSource()
    }
    
    func initDataSource() {
        
        dataSource.contentDidChange = { [weak self] in self?.updateUI() }
        dataSource.fetchData()
    }
    
    func updateUI() {
        
        tableView.reloadData()
        statsCircleView.update(with: dataSource.content)
    }
    
    
    
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsTableViewCell
        
        cell.configure(with: dataSource.content[indexPath.row], dataSource.content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
