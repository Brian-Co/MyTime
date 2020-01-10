//
//  TimerColor.swift
//  MyTime
//
//  Created by Brian Corrieri on 10/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit

enum TimerColor: String {
    case red
    case blue
    case green
    case orange
    
    var create: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        case .orange:
            return UIColor.orange
        }
    }
}
