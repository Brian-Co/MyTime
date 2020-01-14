//
//  EditTimerHandlerDelegate.swift
//  MyTime
//
//  Created by Brian Corrieri on 14/01/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import Foundation

protocol EditTimerHandlerDelegate: class {
    func dismissVC()
    func showAlert(title: String?, message: String?)
}
