//
//  Timer+CoreDataProperties.swift
//  MyTime
//
//  Created by Brian Corrieri on 06/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//
//

import Foundation
import CoreData


extension Timer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timer> {
        return NSFetchRequest<Timer>(entityName: "Timer")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var category: String?
    @NSManaged public var timerInterval: NSSet?

}

// MARK: Generated accessors for timerInterval
extension Timer {

    @objc(addTimerIntervalObject:)
    @NSManaged public func addToTimerInterval(_ value: TimerInterval)

    @objc(removeTimerIntervalObject:)
    @NSManaged public func removeFromTimerInterval(_ value: TimerInterval)

    @objc(addTimerInterval:)
    @NSManaged public func addToTimerInterval(_ values: NSSet)

    @objc(removeTimerInterval:)
    @NSManaged public func removeFromTimerInterval(_ values: NSSet)

}
