//
//  MainTabBarCoordinator.swift
//  MyTime
//
//  Created by Brian Corrieri on 27/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    weak var window: UIWindow?
    weak var tabBarController: UITabBarController?
    
    init(in window: UIWindow, parent: Coordinator) {
        self.window = window
        self.parent = parent
        start()
    }
    
    func start() {
        let mainTabBarController : MainTabBarController = MainTabBarController(didSelectItemIndex: { [weak self] index in
            self?.didSelectItemIndex(index: index)
            }, deinitBlock: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.parent?.removeChild(coordinator: strongSelf)
        })
        self.tabBarController = mainTabBarController
        
        let timersNavigationCoordinator = TimersNavigationCoordinator(in: window, parent: self)
        addChild(coordinator: timersNavigationCoordinator)
        let statsNavigationCoordinator = StatsNavigationCoordinator(in: window, parent: self)
        addChild(coordinator: statsNavigationCoordinator)
        
        self.tabBarController?.viewControllers = [timersNavigationCoordinator.navigationController!, statsNavigationCoordinator.navigationController!]
        
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
    }
    
    func didSelectItemIndex(index: Int) {
        print("MainTabBarController did select index: \(index)")
    }
    
    
}
