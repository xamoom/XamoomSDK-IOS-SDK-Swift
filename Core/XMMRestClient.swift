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
    var query: XMMQuery?
    
    init(baseUrl: URL, session: URLSession){
        self.query = XMMQuery(url: baseUrl)
        self.session = session
    }
    
    func fetchResource(resourceClass: XMMRestResource, headers: [String: String], completion: @escaping(_ data: Data, _ response: URLResponse, _ error: Error) -> Void) -> URLSessionDataTask {
        let requestUrl = (query?.urlWithResource(resourceClass: resourceClass))!
        return makeRestCall(url: requestUrl, headers: headers, resourceClass: resourceClass, complition: completion)
    }
    
    func makeRestCall(url: URL, headers: [String: String], resourceClass: XMMRestResource, complition: @escaping(_ data: Data, _ error: Error) -> Void) -> URLSessionDataTask {
        
        let model = resourceClass.model
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        var task = session!.dataTask(with: request, completionHandler: (data: Data, response: URLResponse, error: Error) -> Void)
        
    }
    
    
}
protocol XMMRestClientDelegate {

    func gotEphemeralId(ephemeralId:String!)
    func gotAuthorizationId(authorizationId:String!)

}

