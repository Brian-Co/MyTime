//
//  Date+Extensions.swift
//  MyTime
//
//  Created by Brian Corrieri on 20/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

extension Date {
    
    func minutesSinceMidnight() -> Double {
        
        let calendar = Calendar(identifier: .gregorian)
        let midnight = calendar.startOfDay(for: self)
        let minutes = self.timeIntervalSince(midnight) / 60
        
        return minutes
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
}
