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
import CoreLocation

public class XMMEnduserApi: XMMRestClientDelegate {
    
    
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
    
    var ephemeralId: String?
    var authorizationId: String?
    var systemLanguage: String!
    var language: String!
    var restClient: XMMRestClient!
    var userDefaults: UserDefaults?
    var pushSound = false
    var noNotification = false
    var lastLocation: CLLocation?
    
    // MARK: - init
    
   public convenience init(apiKey: String) {
        self .init(apiKey: apiKey, isProduction: true)
    }
    
    init(apiKey: String, isProduction: Bool) {
        systemLanguage = systemLanguageWithoutRegionCode()
        language = systemLanguage
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": kHTTPContentType,
                                        "User-Agent": customUserAgentFrom(appName: ""),
                                        "APIKEY": apiKey]
        var apiUrl = ""
        if isProduction {
            apiUrl = kApiProdURLString
        } else {
            apiUrl = kApiDevBaseURLString
        }
        restClient = XMMRestClient(baseUrl: URL(string: apiUrl)!, session: URLSession(configuration: config))
        
        restClient.delegate.self
        pushSound = true
        noNotification = false
        lastLocation = CLLocation.init(latitude: 0.0, longitude: 0.0)
    }
    
    func systemLanguageWithoutRegionCode() -> String {
        return String(Locale.preferredLanguages[0].prefix(2))
    }
    
    // MARK: - PUBLIC METHODS
    
    // MARK: - content calls
    
    public func contentWithId(contentId: String,
                       password: String?,
                       completion: @escaping(_ content: XMMContent?, _ error: Error?, _ passwordRequired: Bool ) -> Void) -> URLSessionDataTask? {
        return contentWithId(contentId: contentId,
                             options: XMMContentOptions(rawValue: 0),
                             reason: XMMContentReason(rawValue: 0)!,
                             password: password,
                             completion: completion)
    }
    
    
    public func contentWithId(contentId: String,
                       options: XMMContentOptions,
                       password: String?,
                       completion: @escaping(_ content: XMMContent?, _ error: Error?, _ passwordRequired: Bool ) -> Void) -> URLSessionDataTask? {
        return contentWithId(contentId: contentId,
                             options: options,
                             reason: XMMContentReason(rawValue: 0)!,
                             password: password,
                             completion: completion)
    }
    
    
    public func contentWithId(contentId: String,
                       options: XMMContentOptions,
                       reason: XMMContentReason,
                       password: String?,
                       completion: @escaping(_ content: XMMContent?, _ error: Error?, _ passwordRequired: Bool ) -> Void) -> URLSessionDataTask? {
        var params = XMMParamHelper.paramsWithLanguage(language: language ?? "")
        
        if options.rawValue > 0 {
            params = XMMParamHelper.addContentOptionsToParams(params: params, options: options)
        }
        var headers = httpHeadersWithEphemeralId()
        headers = addHeaderForReason(headers: headers, reason: reason)
        
        if password != nil {
            let userDefaults = getUserDefaults()
            var passwordEnters = userDefaults.integer(forKey: contentId)
            passwordEnters += 1
            userDefaults.set(passwordEnters, forKey: contentId)
            userDefaults.synchronize()
            userDefaults.set(password, forKey: "X-Password")
        }
        let userDefaults = getUserDefaults()
        
        return restClient.fetchResource(resourceClass: XMMContent.self,
                                        resourceId: contentId,
                                        headers: headers,
                                        parameters: params,
                                        completion: { data, error in
        })
    }
    
    
    
    
    
    // MARK: - XMMRestClientDelegate
    
    func gotEphemeralId(ephemeralId: String!) {
        if getEphemeralId() != ephemeralId {
            self.ephemeralId = ephemeralId
            let userDefaults = getUserDefaults()
            userDefaults.string(forKey: kEphemeralIdKey)
            userDefaults.synchronize()
        }
    }
    
    func gotAuthorizationId(authorizationId: String!) {
        if getAuthorizationId() != authorizationId {
            self.authorizationId = authorizationId
            let userDefaults = getUserDefaults()
            userDefaults.string(forKey: kAuthorizationKey)
            userDefaults.synchronize()
        }
    }
    
    
    // MARK: - EphemeralId
    
    private func addHeaderForReason(headers: [String: String], reason: XMMContentReason) -> [String: String] {
        var mutableHeaders = headers
        if reason.rawValue > 0 {
            mutableHeaders[String(format: "%ld", reason.rawValue)] = kReasonHttpHeaderName
        }
        return mutableHeaders
    }
    
    private func httpHeadersWithEphemeralId() -> [String: String] {
        var headers: [String: String] = [:]
        ephemeralId = getEphemeralId()
        authorizationId = getAuthorizationId()
        
        if ephemeralId != nil {
            print("Ephemeral ID: \(ephemeralId!)")
            headers[kEphemeralIdHttpHeaderName] = ephemeralId!
        }
        if authorizationId != nil {
            print("Authirization ID: \(authorizationId!)")
            headers[kAuthorization] = authorizationId
        }
        return headers
    }
    
    private func getEphemeralId() -> String {
        if ephemeralId != nil {
            return ephemeralId!
        }
        ephemeralId = getUserDefaults().string(forKey: kEphemeralIdKey)
        return ephemeralId ?? ""
    }
    
    private func getAuthorizationId() -> String {
        if authorizationId != nil {
            return authorizationId!
        }
        authorizationId = getUserDefaults().string(forKey: kAuthorizationKey)
        return authorizationId ?? ""
    }
    
    private func getUserDefaults() -> UserDefaults {
        if userDefaults == nil {
            userDefaults = UserDefaults.standard
        }
        return userDefaults!
    }
    
    
    
    
    
    
    
    
    // MARK: - helper
    
    func customUserAgentFrom(appName: String) -> String {
        var appName = appName
        

        let infoDict = Bundle.main.infoDictionary
        let sdkVersion = infoDict?["CFBundleShortVersionString"] as? String

        if appName.count == 0 {
            appName = Bundle.main.bundleIdentifier ?? ""
        }
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let asciiStringData = appName.data(using: .ascii, allowLossyConversion: true)
        if asciiStringData != nil {
            appName = String(data: asciiStringData!, encoding: .ascii) ?? ""
        }
        let customUserAgent = "\(kHTTPUserAgent)|\(appName)-\(appVersion ?? "")|\(sdkVersion ?? "")"
        return customUserAgent
    }
}
