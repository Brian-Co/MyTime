//
//  TimersNavigationCoordinator.swift
//  MyTime
//
//  Created by Brian Corrieri on 09/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import  UIKit

final class TimersNavigationCoordinator: Coordinator {
    
    var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    weak var window: UIWindow?
    weak var navigationController: UINavigationController?
    
    init(in window: UIWindow, parent: Coordinator) {
        self.window = window
        self.parent = parent
        start()
    }
        
    func start() {
        let timersViewController = TimersViewController.controller(dataSource: APITimersDataSource(), didSelectTimer: { [weak self] selectedTimer in
            self?.didSelect(timer: selectedTimer)
        })
        
        let navigationController = UINavigationController(rootViewController: timersViewController)
        self.navigationController = navigationController
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func didSelect(timer: TimerX?) {
        let editTimerVC = EditTimerVC.controller(dataSource: APIEditTimerDataSource(timer: timer), dismiss: { [weak self] in
            self?.editTimerVCDidDimsiss()
        })
        self.navigationController?.pushViewController(editTimerVC, animated: true)
    }
    
    func editTimerVCDidDimsiss() {
        self.navigationController?.popViewController(animated: true)
    }

}
