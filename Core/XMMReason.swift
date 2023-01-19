//
//  File.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 18.01.2023.
//

import Foundation


/**
 * Send XMMContentReason to get better statistics on the xamoom dashboard.
 */
public enum XMMContentReason: Int {
    /// Unkown value.
case unknown = 0
    /// Content is used to display a content link.
case linkedContent = 3
    /// Content is used to show a notification.
case notificationContentRequest = 4
    /// Content is loaded after clicking on an notification.
case notificationContentOpenRequest = 5
    /// Content is loaded and shown because user is near an iBeacon.
case beaconShowContent = 6
    /// Content is loaded to save offline.
case saveContentOffline = 7
    /// Content is loaded to show in a menu.
case menuContentRequest = 8
}
