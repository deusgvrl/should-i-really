//
//  notification_clicked_tests.swift
//  should-i-really
//
//  Created by Steffany Florence on 27/07/26.
//

import Testing
import UserNotifications
@testable import should_i_really

@MainActor
struct NotificationClickTests {
    
    @Test("Notification triggers onNotificationTapped callback when notification is tapped")
    func test_Notification_TriggersCallback_WithPostID() async {
        let storage = StorageController(saveKey: "test_notification_click_3")
        let gameViewModel = GameViewModel(storageController: storage)
        defer { gameViewModel.deleteActiveSave() }
        
        let expectedPostID = "post_300"
        var receivedPostID: String? = nil
        
        NotificationManager.shared.onNotificationTapped = { postID in
            receivedPostID = postID
            Task { @MainActor in
                await gameViewModel.navigateToFeed(postID: postID)
            }
        }
        
        NotificationManager.shared.onNotificationTapped?(expectedPostID)
        
        await Task.yield()
        
        #expect(receivedPostID == expectedPostID)
        #expect(gameViewModel.navigationPath.last == .feedView(postID: expectedPostID))
    }
}
