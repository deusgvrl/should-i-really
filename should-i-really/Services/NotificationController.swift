//
//  NotificationController.swift
//  should-i-really
//
//  Created by Steffany Florence on 16/07/26.
//

import UserNotifications

@MainActor
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            
            Task {
                await self.scheduleLocalNotification()
            }
        }
    }
    
    private func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Wizegram"
        content.body = "doejane commented on your post!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier: "WizegramCommentNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }
}
