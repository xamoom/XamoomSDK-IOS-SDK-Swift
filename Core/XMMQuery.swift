//
//  XMMQuery.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMQuery {
    
    var baseUrl: URL
    
    init(url:URL) {
        self.baseUrl = url
    }
    
    func urlWithResource(resourceClass: XMMRestResource) -> URL {
        let resourceName = resourceClass.resourceName
        return baseUrl.appendingPathComponent(resourceName)
    }
    
    func urlWithResource(resourceClass: XMMRestResource, resourceId: String) -> URL {
        let urlWithResourceName: URL = urlWithResource(resourceClass: resourceClass)
        return urlWithResourceName.appendingPathComponent(resourceId)
    }
    
    func addQueryParametersToUrl(url: URL, parameters:[String: String]) -> URL {
        var parameterArray: [URLQueryItem] = []
        for key in parameters {
            let name = key.key
            let value = parameters[name]
            parameterArray.append(URLQueryItem(name: name, value: value))
        }
        return addQueryStringToUrl(url: url, queryItems: parameterArray)
    }
    
    func addQueryParameterToUrl(url: URL, name: String, value: String) -> URL {
        return addQueryParametersToUrl(url: url, parameters: [name: value])
    }
    
    func addQueryStringToUrl(url: URL, queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        let url = components?.url
        return url!
    }
}


