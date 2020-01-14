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
    case orange
    case teal
    case purple
    case brown
    case green
    case yellow
    case red
    case blue
    
    var create: UIColor {
        switch self {
        case .orange:
            return UIColor.systemOrange
        case .teal:
            return UIColor.systemTeal
        case .purple:
            return UIColor.systemPurple
        case .brown:
            return UIColor.brown
        case .green:
            return UIColor.systemGreen
        case .yellow:
            return UIColor.systemYellow
        case .red:
            return UIColor.systemRed
        case .blue:
            return UIColor.systemBlue
        }
    }
}
