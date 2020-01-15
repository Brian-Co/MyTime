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
        let timerNavigationCoordinator = TimersNavigationCoordinator(in: window, parent: self)
        addChild(coordinator: timerNavigationCoordinator)
    }

}
