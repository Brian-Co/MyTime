//
//  TimerHandler.swift
//  MyTime
//
//  Created by Brian Corrieri on 10/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation


class TimerHandler {
    
    private weak var delegate: TimerHandlerDelegate?
    private var dataSource: TimersDataSource!
    
    init(delegate: TimerHandlerDelegate, dataSource: TimersDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    
    func timerButtonPressed() {
        
        
    }
    
    
    
    
    
}
