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
    
    var onNotificationTapped: ((String) -> Void)?
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermissionAndSchedule(for postID: String) async {
        let center = UNUserNotificationCenter.current()
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            guard granted else { return }
            self.scheduleLocalNotification(for: postID)
            
        } catch {
            print("Failed to authorize notifications: \(error.localizedDescription)")
        }
    }
    
    private func scheduleLocalNotification(for postID: String) {
        let content = UNMutableNotificationContent()
        content.title = "Should I Really?"
        content.body = "doejane commented on your post!"
        content.sound = .default
        
        content.userInfo = ["postID": postID]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(
            identifier: "ShouldIReallyCommentNotification_\(postID)",
            content: content,
            trigger: trigger
        )
        
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
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let postID = userInfo["postID"] as? String {
            print("🔔 Notification clicked for post: \(postID)")
            onNotificationTapped?(postID)
        }
        
        completionHandler()
    }
}
