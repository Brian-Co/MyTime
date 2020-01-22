//
//  EditPopupDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 20/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol EditPopupDataSource {
    var timer: TimerX { get set }
    var timerInterval: TimerInterval { get set }
    var dismissVC: (() -> ())? { get set }
    
    func deleteInterval()
    func saveInterval()
}
