//
//  PolishLanguageModel.swift
//  CleanYourMakeUp
//
//  Created by Jakub Hutny on 24.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation

public class PolishLanguageModel : LanguageProtocol {
    public var LabelText: String {
        get {
            return "Wybierz czas na zmycie makijażu"
        }
    }
    
    public var ButtonText: String {
        get {
            return "Powiadom mnie!"
        }
    }
    
    public var NotificationTitle: String {
        get {
            return "Czas zmyć makijaż!"
        }
    }
    
    public var NotificationBody: String {
        get {
            return "Chwytaj tonik w rękę i do roboty!"
        }
    }
    
    public var AlertTitle: String {
        get {
            return "Zrobione!"
        }
    }
    
    public func getAlertBody(hour: String, minute: String) -> String {
        return "Przypomnimy Ci o zmyciu makijażu o " + hour + ":" + minute + "."
    }
    
    public func currentstateLabel(hour: String, minute: String) -> String {
        return "Przypomnienie obecnie ustawione na " + hour + ":" + minute + "."
    }
}
