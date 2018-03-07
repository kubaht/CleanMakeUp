//
//  NotificationScheduler.swift
//  CleanMakeUp
//
//  Created by Jakub Hutny on 12.10.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

public class NotificationScheduler: NSObject, UNUserNotificationCenterDelegate {
    
    // PRIVATE FIELDS
    private var languageModel: LanguageProtocol
    private let notificationIdentifier = "cleanMakeUpIdentifier"
    private var notificationsIdentifiers = [String]()
    
    init(language: LanguageProtocol) {
        languageModel = language
    }
    
    // PUBLIC METHODS
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        EntityManager.disableAllEntities()
        if notification.request.identifier == "cleanMakeUpIdentifier" {
            completionHandler( [.alert,.sound])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationFiredNotification"), object: nil)
        }
    }
    
    public func scheduleNotification(hour: Int,  minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = languageModel.NotificationTitle
        content.body = languageModel.NotificationBody
        content.sound = UNNotificationSound.default()
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){ }
        }
        notificationsIdentifiers.append(notificationIdentifier)
        EntityManager.disableAllEntities()
        SetupService.create(hour: hour, minute: minute)
    }
    
    public func unscheduleAllPendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: notificationsIdentifiers)
        EntityManager.disableAllEntities()
    }
    
    public func hasAnyPendingNotifications() -> Bool {
        var result = false
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (pendingNotifications: [UNNotificationRequest]) in
            if !pendingNotifications.isEmpty {
                result = true
            }
        }
        
        return result
    }
}
