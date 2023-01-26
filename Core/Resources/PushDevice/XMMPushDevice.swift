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
    
    struct XMMPushDeviceObject: Codable {
        let uid: String?
        let os: String?
        let appVersion: String?
        let appId: String?
        let lastAppOpen: String?
        let updatedAt: String?
        let createdAt: String?
        let location: [String: Double]?
        let language: String?
        let sdkVersion: String?
        let sound: Bool?
        let noNotification: Bool?
    }
}
