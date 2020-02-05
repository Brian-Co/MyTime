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
    
    var timerObserver: NotificationToken?
    var timerIntervalObserver: NotificationToken?
    
    func fetchData() {
        
        let realm = try! Realm()
        timerObserver = realm.objects(TimerRealm.self).observe({ changes in
            let timers = realm.objects(TimerRealm.self)
            self.content = timers.compactMap { $0.toAppModel() }
            
            self.contentDidChange?()
        })
        
        timerIntervalObserver = realm.objects(TimerIntervalRealm.self).observe({ changes in
            let timers = realm.objects(TimerRealm.self)
            self.content = timers.compactMap { $0.toAppModel() }
            
            self.contentDidChange?()
        })
    }
    
    
}
