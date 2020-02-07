//
//  Collection+Extensions.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
