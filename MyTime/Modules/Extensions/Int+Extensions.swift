//
//  Int+Extensions.swift
//  MyTime
//
//  Created by Brian Corrieri on 13/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

extension Int {
    
    func timeString(format: Int? = 0) -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        
        if format == 1 {
            return String(format:"%02i:%02i", hours, minutes)
        } else {
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
}
