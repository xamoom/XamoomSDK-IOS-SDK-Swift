//
//  XMMMenu.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

struct PushDeviceResponse: Codable {
    let data: PushDeviceData?
}


struct PushDeviceData: Codable {
    let id: String?
    let type: String?
    let attributes: PushDeviceAttributes?
}


struct PushDeviceAttributes: Codable {
    let appID, appVersion: String?
    let createdAt: String?
    let language: String?
    let lastAppOpen: String?
    let updatedAt: Date?
    let location: Location?
    let noNotification: Bool?
    let os: String?
    let sdkVersion: String?
    let withSound: Bool?

    enum CodingKeys: String, CodingKey {
        case appID = "app-id"
        case appVersion = "app-version"
        case createdAt = "created-at"
        case language
        case lastAppOpen = "last-app-open"
        case updatedAt = "updated-at"
        case location
        case noNotification = "no-notification"
        case os
        case sdkVersion = "sdk-version"
        case withSound = "with-sound"
    }
}
