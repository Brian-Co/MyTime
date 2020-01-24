//
//  StatsDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 24/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol StatsDataSource {
    
    var content: [TimerX] { get set }
    var contentDidChange: (() -> ())? { get set }
    
    func fetchData()
    
}
