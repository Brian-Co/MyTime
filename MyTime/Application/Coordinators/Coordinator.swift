//
//  Coordinator.swift
//  MyTime
//
//  Created by Brian Corrieri on 09/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    
    var parent: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func addChild(coordinator: Coordinator)
    func removeChild(coordinator: Coordinator)
    
}

extension Coordinator {
    
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

}
