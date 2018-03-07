//
//  EnglishLanguageModel.swift
//  CleanYourMakeUp
//
//  Created by Jakub Hutny on 24.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation

public class EnglishLanguageModel : LanguageProtocol {
    public var LabelText: String {
        get {
            return "Choose time to clean your makeup"
        }
    }
    
    public var ButtonText: String {
        get {
            return "Remind me!"
        }
    }
    
    public var NotificationTitle: String {
        get {
            return "It's time to clean your makeup!"
        }
    }
    
    public var NotificationBody: String {
        get {
            return "Grab your tonic and let's do it!"
        }
    }
    
    public var AlertTitle: String {
        get {
            return "It's done!"
        }
    }
    
    public func getAlertBody(hour: String, minute: String) -> String {
        return "You'll be reminded about cleaning the makeup at " + hour + ":" + minute + "."
    }
    
    public func currentstateLabel(hour: String, minute: String) -> String {
        return "Reminder currently set at " + hour + ":" + minute + "."
    }
}
