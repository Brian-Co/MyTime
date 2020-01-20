//
//  CGPoint+Extensions.swift
//  MyTime
//
//  Created by Brian Corrieri on 20/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    
    func angle(from point: CGPoint) -> CGFloat {
        let originX = point.x - self.x
        let originY = point.y - self.y
        var radians = atan2(originY, originX)
        radians -= CGFloat.pi / 2
        while radians < 0 {
                    radians += CGFloat(2 * Double.pi)
                }
        
        return radians
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - self.x), 2) + pow((point.y - self.y), 2))
    }
    
    
}
