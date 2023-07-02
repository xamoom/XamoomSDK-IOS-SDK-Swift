//
//  File.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 10.02.2023.
//

import Foundation

struct SettingsResponse: Codable {
    let data: SettingsData?
}


struct SettingsData: Codable {
    let id: String?
    let type: String?
    let attributes: SettingsAttributes?
}


struct SettingsAttributes: Codable {
    let appIDGooglePlay, appIDItunes: String?
    let isCookieWarningEnabled: Bool?
    let isEventPackageActive: Bool?
    let isFormsActive: Bool?
    let formsBaseURL: String?
    let googleTagmanagerID: String?
    let isLanguageSwitcherEnabled: Bool?
    let languages: [String]?
    let isRecommendationsActive: Bool?
    let isSocialSharingActive: Bool?

    enum CodingKeys: String, CodingKey {
        case appIDGooglePlay = "app-id-google-play"
        case appIDItunes = "app-id-itunes"
        case isCookieWarningEnabled = "is-cookie-warning-enabled"
        case isEventPackageActive = "is-event-package-active"
        case isFormsActive = "is-forms-active"
        case formsBaseURL = "forms-base-url"
        case googleTagmanagerID = "google-tagmanager-id"
        case isLanguageSwitcherEnabled = "is-language-switcher-enabled"
        case languages
        case isRecommendationsActive = "is-recommendations-active"
        case isSocialSharingActive = "is-social-sharing-active"
    }
}
