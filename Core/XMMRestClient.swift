//
//  XMMRestClient.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMRestClient {
    
    let EPHEMERAL_ID_HEADER = "X-Ephemeral-Id"
    let AUTHORIZATION_ID_HEADER = "Authorization"
    var session: URLSession?
    var query: XMMQuery
    var delegate: XMMRestClientDelegate?
    let decoder = JSONDecoder()
    
    init(baseUrl: URL, session: URLSession){
        self.query = XMMQuery(url: baseUrl)
        self.session = session
    }
    
    func fetchResource(resourceClass: XMMRestResource,
                       headers: [String: String],
                       completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let requestUrl = (query.urlWithResource(resourceClass: resourceClass))
        return makeRestCall(url: requestUrl,
                            headers: headers,
                            complition: completion)
    }
    
    func fetchResource(resourceClass: XMMRestResource,
                       headers: [String: String],
                       parameters: [String: String],
                       completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var requestUrl = (query.urlWithResource(resourceClass: resourceClass))
        requestUrl = (query.addQueryParametersToUrl(url: requestUrl, parameters: parameters))
        return makeRestCall(url: requestUrl,
                            headers: headers,
                            complition: completion)
    }
    
    func fetchResource(resourceClass: XMMRestResource,
                       resourceId: String,
                       headers: [String: String],
                       parameters: [String: String],
                       completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var requestUrl = (query.urlWithResource(resourceClass: resourceClass, resourceId: resourceId))
        requestUrl = (query.addQueryParametersToUrl(url: requestUrl, parameters: parameters))
        return makeRestCall(url: requestUrl,
                            headers: headers,
                            complition: completion)
    }
    
    func voucherStatusWithContentID(contentId: String,
                                    clientID: String,
                                    headers: [String: String],
                                    completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let resourcePath = "consumer/voucher/status"
        var requestUrl = query.baseUrl.appendingPathComponent(resourcePath)
                                      .appendingPathComponent(contentId)
                                      .appendingPathComponent(clientID)
        var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "timestamp", value: "\(Date().timeIntervalSince1970)")]
        requestUrl = (components?.url)!
        return makeRestCall(url: requestUrl,
                            headers: headers,
                            complition: completion)
    }
    
    func redeemVoucherWithContentID(contentId: String,
                                    clientID: String,
                                    redeemCode: String,
                                    headers: [String: String],
                                    completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let resourcePath = "consumer/voucher/redeem"
        var requestUrl = query.baseUrl.appendingPathComponent(resourcePath)
                                      .appendingPathComponent(contentId)
                                      .appendingPathComponent(clientID)
                                      .appendingPathComponent(redeemCode)
        var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "timestamp", value: "\(Date().timeIntervalSince1970)")]
        requestUrl = (components?.url)!
        
       
        return makeRestCall(url: requestUrl,
                            headers: headers,
                            complition: completion)
    }
    
    func postPushDevice(resourceClass: XMMRestResource,
                        resourceId: String,
                        parameters: [String: String],
                        headers: [String: String],
                        device: XMMPushDevice,
                        completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let requestUrl = query.urlWithResource(resourceClass: resourceClass,
                                               resourceId: resourceId)
        return postPushDevice(url: requestUrl,
                              headers: headers,
                              device: device,
                              completion: completion)
    }
    
    func postPushDevice(url: URL,
                        headers: [String: String],
                        device: XMMPushDevice,
                        completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        let body = "NEED SET BODY"
        
        let task = session!.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Rest call error:" + error.localizedDescription)
            }
    }
        task.resume()
        return task
}
    
    func makeRestCall(url: URL,
                      headers:[String: String],
                      complition: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let task = session!.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Rest call error:\(error.localizedDescription)")
                complition(nil, nil, error)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let object = try decoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: data)
                complition(object, nil, nil)
            } catch (let decodingError){
                complition(nil, nil, decodingError)
            }
        }
        task.resume()
        return task
    }
    
    func checkHeaders(headers: [String: String]) {
        let ephemeralId = headers[EPHEMERAL_ID_HEADER]
        if ephemeralId != nil && delegate != nil {
            delegate!.gotEphemeralId(ephemeralId: ephemeralId)
        }
        let authorizationId = headers[AUTHORIZATION_ID_HEADER]
        if authorizationId != nil && delegate != nil {
            delegate!.gotAuthorizationId(authorizationId: authorizationId)
        }
    }
}
protocol XMMRestClientDelegate {

    func gotEphemeralId(ephemeralId:String!)
    func gotAuthorizationId(authorizationId:String!)
}

