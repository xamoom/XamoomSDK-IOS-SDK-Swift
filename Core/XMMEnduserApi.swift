//
//  XMMEnduserApi.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//
/**
 * `XMMEnduserApi` is the main part of the XamoomSDK. You can use it to send api request to the xamoom-api.
 *
 * Use initWithApiKey: to initialize.
 *
 * Change the requested language by setting the language. The users language is
 * saved in systemLanguage.
 *
 * Set offline to true, to get results from offline storage.
 */

import Foundation

public class XMMEnduserApi {
    
    
    let kApiProdURLString = "https://api.xamoom.net/"
    let kApiDevBaseURLString = "https://xamoom-dev.appspot.com/"
    let kHTTPContentType = "application/vnd.api+json"
    let kHTTPUserAgent = "XamoomSDK iOS"
    let kEphemeralIdKey = "com.xamoom.EphemeralId"
    let kAuthorizationKey = "com.xamoom.AuthorizationId"
    let kEphemeralIdHttpHeaderName = "X-Ephemeral-Id"
    let kAuthorization = "Authorization"
    let kReasonHttpHeaderName = "X-Reason"
    let kLastPushRegisterKey = "com.xamoom.last-push-register"
    
    // MARK: - propertis
    
    var ephemeralId = ""
    var authorizationId = ""
    var systemLanguage = ""
    var language = ""
    var restClient: XMMRestClient?
    var userDefaults = UserDefaults()
    var pushSound = false
    var noNotification = false
    var apiKey: String
    
    // MARK: - init
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func initWithApiKey(apiKey: String, isProduction: Bool) {
        systemLanguage = systemLanguageWithoutRegionCode()
        language = systemLanguage
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":kHTTPContentType,
                                        "User-Agent":self.customUserAgentFrom(appName: ""),
                                        "APIKEY":apiKey]
        var apiUrl = ""
        if isProduction {
            apiUrl = kApiProdURLString
        } else {
            apiUrl = kApiDevBaseURLString
        }
        restClient = XMMRestClient(baseUrl: URL(string: apiUrl)!, session: URLSession(configuration: config))
    }
    
    func systemLanguageWithoutRegionCode() -> String {
        return String(Locale.preferredLanguages[0].prefix(2))
    }
    
    // MARK: - helper
    
    func customUserAgentFrom(appName: String) -> String {
        var appName = appName
        let bundle = Bundle(for: XMMEnduserApi.self)
        let url = bundle.url(forResource: "XamoomSDK", withExtension: "bundle")
        var nibBundle: Bundle?
        if let url {
            nibBundle = Bundle(url: url)
        } else {
            nibBundle = bundle
        }
        let infoDict = nibBundle?.infoDictionary
        let sdkVersion = infoDict?["CFBundleShortVersionString"] as? String
        
        if appName.count == 0 {
            appName = Bundle.main.bundleIdentifier ?? ""
        }
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let asciiStringData = appName.data(using: .ascii, allowLossyConversion: true)
        if let asciiStringData {
            appName = String(data: asciiStringData, encoding: .ascii) ?? ""
        }
        let customUserAgent = "\(kHTTPUserAgent)|\(appName)-\(appVersion ?? "")|\(sdkVersion ?? "")"
        return customUserAgent
    }
}
