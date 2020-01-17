//
//  DayCircleViewDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 17/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol DayCircleViewDataSource {
    
    var timers: [TimerX] { get set }
    var loadLayers: (() -> ())? { get set }
    var createTimerIntervalLayer: ((_ startAngle: Double, _ endAngle: Double, _ color: String) -> ())? { get set }
    
}
