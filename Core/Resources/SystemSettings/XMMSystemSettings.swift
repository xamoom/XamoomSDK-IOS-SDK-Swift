//
//  XMMEnduserApi.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * Settings set in the xamoom cloud.
 */

public class XMMSystemSettings: XMMRestResource {
        
    static var resourceName: String {
        return "consumer/settings"
    }
    
    // MARK: - Properties
    
    var googlePlayAppId: String?
    var itunesAppId: String?
    var socialSharingEnabled: Bool?
    var cookieWarningEnabled: Bool?
    var recommendationEnabled: Bool?
    var eventPackageEnabled: Bool?
    var languagePickerEnabled: Bool?
    var languages: [String]?
    var isFormActive: Bool?
    var formsBaseUrl: String? 
}
