//
//  StatsNavigationCoordinator.swift
//  MyTime
//
//  Created by Brian Corrieri on 27/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit


final class StatsNavigationCoordinator: Coordinator {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    weak var window: UIWindow?
    weak var navigationController: UINavigationController?
    
    init(in window: UIWindow?, parent: Coordinator) {
        self.window = window
        self.parent = parent
        start()
    }
        
    func start() {
        let statsVC = StatsVC.controller(dataSource: APIStatsDataSource(), didSelectSettings: { [weak self] in
            self?.didSelectSettings()
        })
        
        let navigationController = UINavigationController(rootViewController: statsVC)
        navigationController.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "chart.pie"), tag: 1)
        self.navigationController = navigationController
        
    }
    
    func didSelectSettings() {
        let settingsVC = SettingsVC.controller(dismiss: { [weak self] in
            self?.popViewController()
        })
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
