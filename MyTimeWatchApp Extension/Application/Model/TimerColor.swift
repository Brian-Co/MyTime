//
//  TimerColor.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import SwiftUI

enum TimerColor: String {
    case orange
    case teal
    case purple
    case brown
    case green
    case yellow
    case red
    case blue
    case clear
    
    var create: Color {
        switch self {
        case .orange:
            return Color.orange
        case .teal:
            return Color.blue
        case .purple:
            return Color.purple
        case .brown:
            return Color.gray
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .red:
            return Color.red
        case .blue:
            return Color.blue
        case .clear:
            return Color.clear
        }
    }
}
