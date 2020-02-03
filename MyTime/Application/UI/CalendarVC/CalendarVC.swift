//
//  CalendarVC.swift
//  MyTime
//
//  Created by Brian Corrieri on 28/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    typealias DidSelectDateBlock = ((Date) -> ())
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var didSelectDate: DidSelectDateBlock?
    var chosenDate = Date()
    
    class func controller(didSelectDate: DidSelectDateBlock?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        controller.didSelectDate = didSelectDate
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.headerTitleColor = .systemBlue
        calendar.appearance.weekdayTextColor = .systemBlue
        
        self.navigationItem.title = "Choose date"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        self.navigationItem.rightBarButtonItem  = doneButton
        
    }
    
    @objc func dismissVC() {
        didSelectDate?(chosenDate)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        chosenDate = date
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}


