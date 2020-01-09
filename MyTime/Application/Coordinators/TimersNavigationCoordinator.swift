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
        
//        let mainTabBarController: MainTabBarController = MainTabBarController(didSelectItemIndex: didSelectItemIndex, deinitBlock: { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.parent?.removeChild(coordinator: strongSelf)
//        })
//        self.tabBarController = mainTabBarController
//        let homeCoordinator: HomeCoordinator = HomeCoordinator(in: mainTabBarController, parent: self)
//        addChild(coordinator: homeCoordinator)
        
        let timersViewControllerDataSource = APITimersDataSource()
        let timersViewController = TimersViewController.controller(dataSource: timersViewControllerDataSource)
        
        let navigationController = UINavigationController(rootViewController: timersViewController)
        self.navigationController = navigationController
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
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
