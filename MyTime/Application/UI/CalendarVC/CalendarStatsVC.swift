//
//  CalendarStatsVC.swift
//  MyTime
//
//  Created by Brian Corrieri on 03/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarStatsVC: UIViewController {
    
    typealias DidSelectDatesBlock = ((Date?, Date?) -> ())
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var didSelectDates: DidSelectDatesBlock?
    private var firstDate: Date?
    private var lastDate: Date?
    private var chosenDates: [Date]?
    
    class func controller(didSelectDates: DidSelectDatesBlock?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarStatsVC") as! CalendarStatsVC
        controller.didSelectDates = didSelectDates
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.headerTitleColor = .systemBlue
        calendar.appearance.weekdayTextColor = .systemBlue
        
        self.navigationItem.title = "Choose date range"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        self.navigationItem.rightBarButtonItem  = doneButton
        
    }
    
    @objc func dismissVC() {
        didSelectDates?(firstDate, lastDate)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CalendarStatsVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if firstDate == nil {
            firstDate = date
            chosenDates = [firstDate!]

            return
        }

        if firstDate != nil && lastDate == nil {

            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                chosenDates = [firstDate!]

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            chosenDates = range

            return
        }

        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            chosenDates = []
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}




