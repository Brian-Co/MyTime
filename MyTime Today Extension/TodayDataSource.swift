//
//  TodayDataSource.swift
//  MyTime Today Extension
//
//  Created by Brian Corrieri on 27/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import IceCream

protocol TodayDataSource {
    
    var syncEngine: SyncEngine? { get set }
    var updateUI: ((_ timer: TimerX) -> ())? { get set }
    
    func start()
    func addTimer()
    func update(_ timer: TimerX)
    
}
