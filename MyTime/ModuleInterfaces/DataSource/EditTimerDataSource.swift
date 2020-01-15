//
//  EditTimerDataSource.swift
//  MyTime
//
//  Created by Brian Corrieri on 15/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol EditTimerDataSource {
    
    var timer: TimerX { get set }
    var showAlert: ((_ title: String, _ message: String) -> ())? { get set }
    var dismissVC: (() -> ())? { get set }
    
    func save()
    func delete()
}


