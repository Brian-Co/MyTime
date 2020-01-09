//
//  RootCoordinator.swift
//  MyTime
//
//  Created by Brian Corrieri on 08/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit

final class RootCoordinator: Coordinator {
    
    var window: UIWindow!
    var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
//        window = UIWindow(frame: UIScreen.main.bounds)

// More logic will come here to manage different application states.
        
        let timerNavigationCoordinator = TimersNavigationCoordinator(in: window, parent: self)
        addChild(coordinator: timerNavigationCoordinator)
    }
    
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    //        logTree()
        }
    
    func removeChild(coordinator: Coordinator) {
//        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    //        logTree()
        }
    
}
