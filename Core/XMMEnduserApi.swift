//
//  XMMEnduserApi.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//


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
    var systemLanguage: String?
    var language: String?
    var restClient: XMMRestClient?
    var userDefaults: UserDefaults?
    var pushSound: Bool?
    var noNotification: Bool?
    var lastLocation: CLLocation?
    var apiUrl: String?
    
    // MARK: - sharedInstance
    
    static var sharedInstance: XMMEnduserApi?
    static func sharedInstance(with apiKey: String) -> XMMEnduserApi {
        assert(apiKey.isEmpty == false, "apikey is nil. Please use an apikey")
        if sharedInstance == nil {
            sharedInstance = XMMEnduserApi(apiKey: apiKey)
        }
        return sharedInstance!
    }
    
    static func saveSharedInstance(_ instance: XMMEnduserApi) {
        sharedInstance = instance
    }
    
    // MARK: - init
    
   public convenience init(apiKey: String) {
       self.init(apiKey:apiKey, isProduction: true)
    }
    
    init(apiKey: String, isProduction: Bool) {
        self.systemLanguage = systemLanguageWithoutRegionCode()
        language = systemLanguage
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": kHTTPContentType,
                                        "User-Agent": customUserAgentFrom(appName: ""),
                                        "APIKEY": apiKey]
        
        if isProduction {
            self.apiUrl = kApiProdURLString
        } else {
            self.apiUrl = kApiDevBaseURLString
        }
        self.restClient = XMMRestClient(baseUrl: URL(string: self.apiUrl!)!, session: URLSession(configuration: config))
        
        self.pushSound = true
        self.noNotification = false
        self.lastLocation = CLLocation.init(latitude: 0.0, longitude: 0.0)
    }
    
    func systemLanguageWithoutRegionCode() -> String {
        return String(Locale.preferredLanguages[0].prefix(2))
    }
    
    // MARK: - PUBLIC METHODS
    
    // MARK: - CONTENT CALLS
    // MARK: - content with id
    
    public func content(WithId contentId: String,
                       password: String?,
                       completion: @escaping(_ content: XMMContent?, _ error: Error?, _ passwordRequired: Bool ) -> Void) -> URLSessionDataTask? {
        
        return content(WithId: contentId,
                             options: XMMContentOptions(rawValue: 0),
                             reason: XMMContentReason(rawValue: 0)!,
                             password: password,
                             completion: completion)
    }
    
    
    public func content(WithId contentId: String,
                       options: XMMContentOptions,
                       password: String?,
                       completion: @escaping(_ content: XMMContent?, _ error: Error?, _ passwordRequired: Bool ) -> Void) -> URLSessionDataTask? {
        
        return content(WithId: contentId,
                             options: options,
                             reason: XMMContentReason(rawValue: 0)!,
                             password: password,
                             completion: completion)
    }
    
    
    public func content(WithId contentId: String,
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
            userDefaults.set(password, forKey: "X-Password")
        }
        
        return restClient!.fetchResource(resourceClass: XMMContent.self,
                                        resourceId: contentId,
                                        headers: headers,
                                        parameters: params,
                                              completion: { (data, error) in
            if let error = error {
                
                switch error {
                case XMMRestClient.ApiError.statusCode(401):
                    if self.shouldShowPassword(ForContentId: contentId, pasword: password!, error: error, completion: completion) {
                        completion(nil, error, true)
                        return
                    }
                    return
                    
                case XMMRestClient.ApiError.statusCode(404):
                    self.contents(WithTags: ["x-forbidden"], pageSize: 10, cursor: nil, sortOptions: nil) { (contents, hasMore, cursor, error) in
                        
                        if let error {
                            completion(nil, error, false)
                            return
                        }
                        if contents.first != nil {
                            completion(contents.first as? XMMContent, nil, false)
                            return
                        }
                    }
                    return
                default:
                    self.userDefaults?.setValue(0, forKey: contentId)
                    completion(nil, error, false)
                    return
                }
            }
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(ContentResponse.self, from: data!)
                print (model)
                let content = XMMContent(model)
                completion(content, error, false)
                
            } catch let error {
                print(error)
            }
        })
    }
    
    // MARK: - content with location identifier
    
    public func content(WithLocationIdentifier locationIdentifier: String,
                                              password: String?,
                                              completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask {
        
        return content(WithLocationIdentifier: locationIdentifier,
                                             options: XMMContentOptions(rawValue: 0),
                                             password: password,
                                             completion: completion)
    }
    
    
    public func content(WithLocationIdentifier locationIdentifier: String,
                                              options: XMMContentOptions,
                                              password: String?,
                                              completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask {
        
        return content(WithLocationIdentifier: locationIdentifier,
                                             options: options,
                                             conditions: nil,
                                             password: password,
                                             completion: completion)
    }
    
    
    public func content(WithLocationIdentifier locationIdentifier: String,
                                              options: XMMContentOptions,
                                              conditions: [String: String]?,
                                              password: String?,
                                              completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask {
        
        return content(WithLocationIdentifier: locationIdentifier,
                                             options: options,
                                             conditions: conditions ?? nil,
                                             reason: XMMContentReason(rawValue: 0)!, password: password, completion: completion)
    }
    
    
    public func content(WithLocationIdentifier locationIdentifier: String,
                                              options: XMMContentOptions,
                                              conditions: [String: String]?,
                                              reason: XMMContentReason,
                                              password: String?,
                                              completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask {
        let userDefault = self.getUserDefaults()
        var mutableConditions: [String: Any] = [:]
        if conditions != nil {
            mutableConditions = conditions!
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let dateTime = calendar.date(from: components)
        mutableConditions["x-datetime"] = [dateTime]
        
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!, identifier: locationIdentifier)
        params = XMMParamHelper.addContentOptionsToParams(params: params, options: options)
        params = XMMParamHelper.addConditionsToParams(params: params, conditions: conditions ?? [:])
        
        var headers = self.httpHeadersWithEphemeralId()
        headers = self.addHeaderForReason(headers: headers, reason: reason)
        
        if password != nil {
            var passwordEnters = userDefault.integer(forKey: locationIdentifier)
            passwordEnters += 1
            userDefault.set(passwordEnters, forKey: locationIdentifier)
            headers["X-Password"] = password
        }
        return self.restClient!.fetchResource(resourceClass: XMMContent.self,
                                             headers: headers,
                                             parameters: params,
                                             completion: { (data, error) in
        })
    }
    
    // MARK: - content with beacon
    
    public func contentWithBeaconMajor(major: Int,
                                       minor: Int,
                                       completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask{
        let locationIdentifire = "\(major)|\(minor)"
        
        return content(WithLocationIdentifier: locationIdentifire,
                                                  password: nil,
                                                  completion: completion)
    }
    
    
     
    public func content(WithBeaconMajor major: Int,
                                       minor: Int,
                                       option: XMMContentOptions,
                                       completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask{
        let locationIdentifire = "\(major)|\(minor)"
        
        return content(WithLocationIdentifier: locationIdentifire,
                                                  options: option,
                                                  password: nil,
                                                  completion: completion)
    }
    
    
    public func content(WithBeaconMajor major: Int,
                                       minor: Int,
                                       option: XMMContentOptions,
                                       conditions: [String: String]?,
                                       completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask{
        let locationIdentifire = "\(major)|\(minor)"
        
        return content(WithLocationIdentifier: locationIdentifire,
                                                  options: option,
                                                  conditions: conditions ?? nil,
                                                  password: nil,
                                                  completion: completion)
    }
    
    
    public func content(WithBeaconMajor major: Int,
                                       minor: Int,
                                       option: XMMContentOptions,
                                       conditions: [String: String]?,
                                       reason: XMMContentReason,
                                       completion: @escaping(_ content: XMMContent, _ error: Error, _ passwordRequired: Bool) -> Void) -> URLSessionDataTask{
        let locationIdentifire = "\(major)|\(minor)"
        
        return content(WithLocationIdentifier: locationIdentifire,
                                                  options: option,
                                                  conditions: conditions ?? nil,
                                                  reason: reason,
                                                  password: nil,
                                                  completion: completion)
    }
    
    // MARK: - content with location
    
    public func content(sWithLocation location: CLLocation,
                                     pageSize: Int,
                                     cursor: String,
                                     sortOptions: XMMContentSortOptions,
                                     completion: @escaping(_ contents: [Any], _ hasMore: Bool, _ cursor: String, _ error: Error) -> Void) -> URLSessionDataTask {
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!, location: location)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addContentSortOptionsToParams(params: params, options: sortOptions)
        
        return restClient!.fetchResource(resourceClass: XMMContent.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
        })
    }
    
    // MARK: - content with tags
    
    public func contents(WithTags tags: [String],
                                 pageSize: Int,
                                 cursor: String?,
                                 sortOptions: XMMContentSortOptions?,
                                 completion: @escaping(_ contents: [Any], _ hasMore: Bool, _ cursor: String, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        return self.contents(WithTags: tags,
                                     pageSize: pageSize,
                                     cursor: cursor,
                                     sortOptions: sortOptions,
                                     filter: nil,
                                     completion: completion)
    }
    
    
    public func contents(WithTags tags: [String],
                                 pageSize: Int,
                                 cursor: String?,
                                 sortOptions: XMMContentSortOptions?,
                                 filter: XMMFilter?,
                                 completion: @escaping(_ contents: [Any], _ hasMore: Bool, _ cursor: String, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let filter = XMMFilter.makeWithBuilder(updateBlock: {builder in
            builder.tags = tags
            builder.name = filter?.name
            builder.fromDate = filter?.fromDate
            builder.toDate = filter?.toDate
            builder.relatedSpotID = filter?.relatedSpotID
        })
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addFiltersToParams(params: params, filters: filter)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addContentSortOptionsToParams(params: params, options: sortOptions!)
        
        return self.restClient!.fetchResource(resourceClass: XMMContent.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
        })
    }
    
    // MARK: - content with name
    
    public func contents(WithName name: String,
                                 pageSize: Int,
                                 cursor: String,
                                 sortOptions: XMMContentSortOptions,
                                 completion: @escaping(_ contents: [Any], _ hasMore: Bool, _ cursor: String, _ error: Error) -> Void) -> URLSessionDataTask {
        
        return contents(WithName: name,
                                     pageSize: pageSize,
                                     cursor: cursor,
                                     sortOptions: sortOptions,
                                     filter: nil,
                                     completion: completion)
    }
    
    
    public func contents(WithName name: String,
                                 pageSize: Int,
                                 cursor: String,
                                 sortOptions: XMMContentSortOptions,
                                 filter: XMMFilter?,
                                 completion: @escaping(_ contents: [Any], _ hasMore: Bool, _ cursor: String, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let filters = XMMFilter.makeWithBuilder(updateBlock: {builder in
            builder.name = name
            builder.tags = filter?.tags
            builder.fromDate = filter?.fromDate
            builder.toDate = filter?.toDate
            builder.relatedSpotID = filter?.relatedSpotID
        })
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addFiltersToParams(params: params, filters: filters)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addContentSortOptionsToParams(params: params, options: sortOptions)
        
        return self.restClient!.fetchResource(resourceClass: XMMContent.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
        })
    }
    
    // MARK: - content with date
    
    public func contents(From fromeDate: Date,
                             toDate: Date,
                             relatedSpotID: String,
                             pageSize: Int,
                             cursor: String,
                             sortOption: XMMContentSortOptions, completion: @escaping(_ contents: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        let filters = XMMFilter.makeWithBuilder(updateBlock: { builder in
            builder.fromDate = fromeDate
            builder.toDate = toDate
            builder.relatedSpotID = relatedSpotID
        })
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addFiltersToParams(params: params, filters: filters)
        params = XMMParamHelper.addContentSortOptionsToParams(params: params, options: sortOption)
        
        return self.restClient!.fetchResource(resourceClass: XMMContent.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
            if let error = error {
                completion(nil, false, nil, error)
            }
            if let data = data {
                print("Content from succes")
            }
        })
    }
    
    // MARK: - Content recomendation
    
    public func contentRecommendations(WithCompletion completion: @escaping( _ contents: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        if self.getEphemeralId() == "" {
            print("Content Recommendations not available without ephemeral id, please first call backend another way.")
            completion(nil, false, nil, NSError(domain: "com.xamoom",
                                                code: 0,
                                                userInfo: ["detail" : "Content Recommendations not available without ephemeral id, please first call backend another way"]))
            
            return nil
        }
        
        if self.getAuthorizationId() == "" {
            print("Content Recommendations not available without authorization id, please first call backend another way.")
            completion(nil, false, nil, NSError(domain: "com.xamoom",
                                                code: 0,
                                                userInfo: ["detail" : "Content Recommendations not available without authorization id, please first call backend another way."]))
            
            return nil
        }
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addRecommendationsToParams(params: params)
        
        let headers = self.httpHeadersWithEphemeralId()
        
        return self.restClient!.fetchResource(resourceClass: XMMContent.self,
                                             headers: headers,
                                             parameters: params,
                                             completion: { (data, error) in
            if let error = error {
                completion(nil, false, nil, error as NSError)
            }
            if let data = data {
                print("Content decommendations succes")
            }
        })
    }
    
    // MARK: - SPOT CALLS
    // MARK: - spot with ID
    
    public func spot(WithId spotId: String,
                           completion: @escaping( _ spot: XMMSpot?, _ error: Error?) -> Void) -> URLSessionDataTask {
        return self.spot(WithId: spotId,
                               options: .XMMSpotOptionsNone,
                               completion: completion)
    }
    
    
    public func spot(WithId spotId: String,
                           options: XMMSpotOptions,
                           completion: @escaping( _ spot: XMMSpot?, _ error: Error?) -> Void) -> URLSessionDataTask {
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addSpotOptionsToParams(params: params, options: options)
        
        return self.restClient!.fetchResource(resourceClass: XMMSpot.self,
                                             resourceId: spotId,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                print("Spot with id succes")
            }
        })
    }
    
    // MARK: - spot with location
    
    public func spot(WithLocation location: CLLocation,
                                 radius: Int,
                                 options: XMMSpotOptions,
                                 sortOptions: XMMSpotSortOptions,
                                 completion: @escaping( _ spot: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        return self.spot(WithLocation: location,
                                     radius: radius,
                                     options: options,
                                     sortOptions: sortOptions,
                                     pageSize: 0,
                                     cursor: nil,
                                     completion: completion)
    }
    
    
    public func spot(WithLocation location: CLLocation,
                                 radius: Int,
                                 options: XMMSpotOptions,
                                 sortOptions: XMMSpotSortOptions,
                                 pageSize: Int,
                                 cursor: String?,
                                 completion: @escaping( _ spot: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: Error) -> Void) -> URLSessionDataTask {
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!, location: location, radius: radius)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addSpotOptionsToParams(params: params, options: options)
        params = XMMParamHelper.addSpotSortOptionsToParams(params: params, options: sortOptions)
        
        return self.restClient!.fetchResource(resourceClass: XMMSpot.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            if let error = error {
                completion(nil, false, nil, error)
                return
            }
            if let data = data {
                print("Spot with location succes")
            }
        })
    }
    
    // MARK: - spot with tags
    
    public func spots(WithTags tags: [String],
                              options: XMMSpotOptions,
                              sortOptions: XMMSpotSortOptions,
                              completion: @escaping(_ spots: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        return self.spots(WithTags: tags,
                                  pageSize: 100,
                                  cursor: nil,
                                  options: options,
                                  sortOptions: sortOptions,
                                  completion: completion)
    }
    
    
    public func spots(WithTags tags: [String],
                              pageSize: Int,
                              cursor: String?,
                              options: XMMSpotOptions,
                              sortOptions: XMMSpotSortOptions,
                              completion: @escaping(_ spots: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: Error) -> Void) -> URLSessionDataTask {
        let filters = XMMFilter.makeWithBuilder(updateBlock: { builder in
            builder.tags = tags
        })
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addFiltersToParams(params: params, filters: filters)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addSpotOptionsToParams(params: params, options: options)
        params = XMMParamHelper.addSpotSortOptionsToParams(params: params, options: sortOptions)
        
        return self.restClient!.fetchResource(resourceClass: XMMSpot.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
            if let error = error {
                completion(nil, false, nil, error)
                return
            }
            if let data = data {
                print("Spots with tags succes")
            }
        })
    }
    
    // MARK: - spot with name
    
    public func spots(WithName name: String,
                              pageSize: Int,
                              cursor: String,
                              options: XMMSpotOptions,
                              sortOptions: XMMSpotSortOptions,
                              completion: @escaping(_ spots: [Any]?, _ hasMore: Bool, _ cursor: String?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let filters = XMMFilter.makeWithBuilder(updateBlock: { builder in
            builder.name = name
        })
        var params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        params = XMMParamHelper.addFiltersToParams(params: params, filters: filters)
        params = XMMParamHelper.addPagingToParams(params: params, pageSize: pageSize, cursor: cursor)
        params = XMMParamHelper.addSpotOptionsToParams(params: params, options: options)
        params = XMMParamHelper.addSpotSortOptionsToParams(params: params, options: sortOptions)
        
        return self.restClient!.fetchResource(resourceClass: XMMSpot.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            if let error = error {
                completion(nil, false, nil, error)
                return
            }
            if let data = data {
                print("Spot with name succes")
            }
        })
    }
    
    // MARK: - SYSTEM CALLS
    // MARK: - system with completion
    
    public func system(WithCompletion completion: @escaping(_ system: XMMSystem?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        
        return self.restClient!.fetchResource(resourceClass: XMMSystem.self,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                print("System with completion succes")
            }
        })
    }
    
    // MARK: - system settings with id
    
    public func system(SettingsWithID settingsId: String,
                                     completion: @escaping(_ settings: XMMSystemSettings?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        
        return self.restClient!.fetchResource(resourceClass: XMMSystemSettings.self,
                                             resourceId: settingsId,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                print("System settings with completion succes")
            }
        })
    }
    
    // MARK: - style with id
    
    public func style(WithID styleId: String,
                            completion: @escaping(_ style: XMMStyle?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        
        return self.restClient!.fetchResource(resourceClass: XMMStyle.self,
                                             resourceId: styleId,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                print("System settings with completion succes")
            }
        })
    }
    
    // MARK: - menu with id
    
    public func menu(WithID menuId: String,
                            completion: @escaping(_ menu: XMMMenu?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let params = XMMParamHelper.paramsWithLanguage(language: self.language!)
        
        return self.restClient!.fetchResource(resourceClass: XMMMenu.self,
                                             resourceId: menuId,
                                             headers: self.httpHeadersWithEphemeralId(),
                                             parameters: params,
                                             completion: { (data, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                print("System settings with completion succes")
            }
        })
    }
    
    // MARK: - voucher status with id
    
    public func voucherStatus(WithContendID contentId: String,
                                           clientId: String?, completion: @escaping(_ isRedeemable: Bool?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        return self.restClient!.voucherStatus(WithContentID: contentId,
                                                          clientID: clientId ?? self.getEphemeralId(),
                                                          headers: self.httpHeadersWithEphemeralId(),
                                                          completion: { (data, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data{
                print("Voucher status succes")
            }
        })
    }
    
    // MARK: - redeem voucher with id
    
    public func redeemVoucher(WithContendID contentId: String,
                                           clientId: String?,
                                           readeemCode: String,
                                           completion: @escaping(_ isRedeemable: Bool?, _ error: Error) -> Void) -> URLSessionDataTask {
        
        return self.restClient!.redeemVoucher(WithContentID: contentId,
                                                          clientID: clientId ?? self.getEphemeralId(),
                                                          redeemCode: readeemCode,
                                                          headers: self.httpHeadersWithEphemeralId(),
                                                          completion: { (data, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data{
                print("Redeem voucher status succes")
            }
        })
    }
    
    // MARK: - push device
    
    public func pushDevice(instantPush: Bool) -> URLSessionDataTask? {
        let storage = XMMSimpleStorage()
        let userDefault = self.getUserDefaults()
        
        let lastPush = userDefault.double(forKey: self.kLastPushRegisterKey)
        var location = storage.getLocation()
        
        if location == nil {
            location = CLLocation(latitude: 0.0, longitude: 0.0)
        }
        
        // Checks if new location distance less than 100 meters. If true do nothing.
        if !instantPush && self.lastLocation!.distance(from: location!) < 100 {
            return nil
        }
        if !instantPush && lastPush != 0.0 && lastPush > Date().timeIntervalSince1970 - 30.0 * 60.0 {
            return nil
        }
        
        let token = storage.getUserToken()
        let infoDictionary = Bundle.main.infoDictionary
        let version = infoDictionary?["CFBundleShortVersionString"] as? String
        let appId = infoDictionary?["CFBundleIdentifier"] as? String
        let sdkVersion = "3.11.20"
        
        if token != nil && version != nil && appId != nil {
            
            let locationDictionary = ["lat": Double(location!.coordinate.latitude),
                                      "lon": Double(location!.coordinate.longitude)]
            
            let pushLog = self.pushSound! ? "Push Device sound: YES" : "Push Device sound: No"
            print(pushLog)
            
            let notificationLog = self.noNotification! ? "Disabled push" : "Enabled push"
            print(notificationLog)
            
            self.lastLocation = location!
            
            let now = Date().timeIntervalSince1970
            userDefault.set(now, forKey: kLastPushRegisterKey)
            
            let device = XMMPushDevice.XMMPushDeviceObject(uid: token,
                                                           os: nil,
                                                           appVersion: version,
                                                           appId: appId,
                                                           lastAppOpen: nil,
                                                           updatedAt: nil,
                                                           createdAt: nil,
                                                           location: locationDictionary,
                                                           language: nil,
                                                           sdkVersion: sdkVersion,
                                                           sound: self.pushSound,
                                                           noNotification: self.noNotification)
            print("Device Pushed")
            return self.restClient!.postPushDevice(resourceClass: XMMPushDevice.self, resourceId: token!, parameters: nil, headers: self.httpHeadersWithEphemeralId(), device: device, completion: { (responce, error) in
                
                if let error = error {
                    print("Push device error: \(error.localizedDescription)")
                    userDefault.set(0.0, forKey: self.kLastPushRegisterKey)
                }
            })
            
            
        }
        return nil
    }
    
    
    
    
    
    
    
    
    // MARK: - XMMRestClientDelegate
    
    func gotEphemeralId(ephemeralId: String!) {
        if getEphemeralId() != ephemeralId {
            self.ephemeralId = ephemeralId
            let userDefaults = getUserDefaults()
            userDefaults.string(forKey: kEphemeralIdKey)
        }
    }
    
    func gotAuthorizationId(authorizationId: String!) {
        if getAuthorizationId() != authorizationId {
            self.authorizationId = authorizationId
            let userDefaults = getUserDefaults()
            userDefaults.string(forKey: kAuthorizationKey)
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
        if self.ephemeralId != nil {
            return self.ephemeralId!
        }
        self.ephemeralId = getUserDefaults().string(forKey: kEphemeralIdKey)
        return self.ephemeralId ?? ""
    }
    
    private func getAuthorizationId() -> String {
        if self.authorizationId != nil {
            return self.authorizationId!
        }
        self.authorizationId = getUserDefaults().string(forKey: kAuthorizationKey)
        return self.authorizationId ?? ""
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
    
    func setPushSound(s: Bool) {
        let userDefaults = self.getUserDefaults()
        userDefaults.set(s, forKey: "pushSound")
    }
    
    func getPushSound() -> Bool {
        let userDefault = self.getUserDefaults()
        let sound = userDefault.bool(forKey: "pushSound")
        return sound
    }
    
    func setNoNotification(noNotification: Bool) {
        let userDefaults = getUserDefaults()
        userDefaults.set(noNotification, forKey: "noNotification")
    }
    
    func getNoNotification() -> Bool {
        let userDefault = self.getUserDefaults()
        let notification = userDefault.bool(forKey: "noNotification")
        return notification
    }
    
    func shouldShowPassword(ForContentId contentId: String, pasword: String, error: Error, completion: @escaping(XMMContent?, Error?, _ paswowordReguired: Bool) -> Void) -> Bool {
        
        let nextPasswordKey = "next_\(contentId)"
        let userDefault = getUserDefaults()
        
        let passwordEnters = userDefault.integer(forKey: contentId)
        let lastDate = userDefault.object(forKey: nextPasswordKey) as? Date
        
        if let lastDate {
            let now = Date()
            let earliestOpenDate = lastDate.addingTimeInterval(15 * 60)
            if earliestOpenDate.compare(now) == .orderedDescending {
                contents(WithTags: ["x-forbidden"], pageSize: 10, cursor: nil, sortOptions: nil) { contents, hasMore, cursor, error in
                    
                    if let error {
                        completion(nil, error, false)
                        return
                    }
                    if contents.first != nil {
                        completion(contents.first as? XMMContent, nil, false)
                        return
                    } else {
                        completion(nil, error, false)
                        return
                    }
                }
                return false
            }
        }
        if (passwordEnters < 3) {
            return true
            
        } else {
            let now = Date()
            userDefault.setValue(now, forKey: nextPasswordKey)
            userDefault.setValue(0, forKey: contentId)
            contents(WithTags: ["x-forbidden"], pageSize: 10, cursor: nil, sortOptions: nil) { contents, hasMore, cursor, error in
                
                if let error {
                    completion(nil, error, false)
                    return
                }
                if contents.first != nil {
                    completion(contents.first as? XMMContent, nil, false)
                    return
                } else {
                    completion(nil, error, false)
                    return
                }
            }
            return false
        }
    }
    
    func shouldShowPassword(ForLocId locationIdentifier: String, pasword: String, error: Error, completion: @escaping(XMMContent?, Error?, _ paswowordReguired: Bool) -> Void) -> Bool {
        
        let nextPasswordKey = "next_\(locationIdentifier)"
        let userDefault = getUserDefaults()
        
        let passwordEnters = userDefault.integer(forKey: locationIdentifier)
        let lastDate = userDefault.object(forKey: nextPasswordKey) as? Date
        
        if let lastDate {
            let now = Date()
            let earliestOpenDate = lastDate.addingTimeInterval(15 * 60)
            if earliestOpenDate.compare(now) == .orderedDescending {
                contents(WithTags: ["x-forbidden"], pageSize: 10, cursor: nil, sortOptions: nil) { contents, hasMore, cursor, error in
                    
                    if let error {
                        completion(nil, error, false)
                        return
                    }
                    if contents.first != nil {
                        completion(contents.first as? XMMContent, nil, false)
                        return
                    } else {
                        completion(nil, error, false)
                        return
                    }
                }
                return false
            }
        }
        if (passwordEnters < 3) {
            return true
            
        } else {
            let now = Date()
            userDefault.setValue(now, forKey: nextPasswordKey)
            userDefault.setValue(0, forKey: locationIdentifier)
            contents(WithTags: ["x-forbidden"], pageSize: 10, cursor: nil, sortOptions: nil) { contents, hasMore, cursor, error in
                
                if let error {
                    completion(nil, error, false)
                    return
                }
                if contents.first != nil {
                    completion(contents.first as? XMMContent, nil, false)
                    return
                } else {
                    completion(nil, error, false)
                    return
                }
            }
            return false
        }
    }
}
