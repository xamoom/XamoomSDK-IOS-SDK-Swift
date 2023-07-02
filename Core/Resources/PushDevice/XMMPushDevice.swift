//
//  XMMPushDevice.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 11.01.2023.
//

import Foundation

public class XMMPushDevice: XMMRestResource {
    
    static var resourceName: String {
        return "customer/push-register"
    }
    
    // MARK: - Properties
    
    var uid: String?
    var os: String?
    var appVersion: String?
    var appId: String?
    var lastAppOpen: String?
    var updatedAt: String?
    var createdAt: String?
    var location: [String: Double]?
    var language: String?
    var sdkVersion: String?
    var sound: Bool?
    var noNotification: Bool?
}
