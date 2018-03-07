//
//  PickerViewModel.swift
//  CleanYourMakeUp
//
//  Created by Jakub Hutny on 24.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation

public class PickerViewModel {
    // PRIVATE FIELDS
    private var hours = [String]()
    private var minutes = [String]()
    
    // INITIALIZERS
    
    init() {
        createHours()
        createMinutes()
    }
    
    // PROPERTIES
    
    public var Hours: [String] {
        get {
            return hours
        }
    }
    
    public var Minutes: [String] {
        get {
            return minutes
        }
    }
    
    // PRIVATE METHODS
    
    private func createHours() {
        for hour in 0...9 {
            hours.append("0" + String(hour))
        }
        for hour in 10...23 {
            hours.append(String(hour))
        }
    }
    
    private func createMinutes() {
        for minute in 0...9 {
            minutes.append("0" + String(minute))
        }
        for minute in 10...59 {
            minutes.append(String(minute))
        }
    }
}
