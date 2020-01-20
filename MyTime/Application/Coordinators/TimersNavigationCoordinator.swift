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
        }, didSelectInterval: { [weak self] timer, timerInterval in
            self?.didSelectInterval(timer, timerInterval)
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
    
    func didSelectInterval(_ timer: TimerX, _ timerInterval: TimerInterval) {
        let editPopup = EditPopup.controller(dataSource: APIEditPopupDataSource(timer: timer, timerInterval: timerInterval))
        editPopup.modalPresentationStyle = .overCurrentContext
        editPopup.modalTransitionStyle = .crossDissolve
        
        self.navigationController?.present(editPopup, animated: true, completion: nil)
    }

}
