//
//  APIStatsDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 24/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import RealmSwift


class APIStatsDataSource: StatsDataSource {
    
    
    var content: [TimerX] = []
    var contentDidChange: (() -> ())?
    
    func fetchData() {
        
        let realm = try! Realm()
        let timers = realm.objects(TimerRealm.self)
        self.content = timers.compactMap { $0.toAppModel() }
        
        contentDidChange?()
    }
    
    
}
