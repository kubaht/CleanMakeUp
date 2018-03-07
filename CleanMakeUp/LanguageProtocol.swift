//
//  LanguageProtocol.swift
//  CleanYourMakeUp
//
//  Created by Jakub Hutny on 24.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation

public protocol LanguageProtocol {
    var LabelText : String{ get }
    var ButtonText: String { get }
    var NotificationTitle: String { get }
    var NotificationBody: String { get }
    var AlertTitle: String { get }
    func getAlertBody(hour: String, minute: String) -> String
    func currentstateLabel(hour: String, minute: String) -> String
}
