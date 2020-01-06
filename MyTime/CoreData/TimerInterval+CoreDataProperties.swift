//
//  TimerInterval+CoreDataProperties.swift
//  MyTime
//
//  Created by Brian Corrieri on 06/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//
//

import Foundation
import CoreData


extension TimerInterval {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimerInterval> {
        return NSFetchRequest<TimerInterval>(entityName: "TimerInterval")
    }

    @NSManaged public var startingPoint: Date?
    @NSManaged public var duration: Int64
    @NSManaged public var intervalOfTimer: Timer?

}
