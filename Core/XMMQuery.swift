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
    
    func urlWithResource(resourceClass: Any) -> URL {
        var resourceName: String = ""
        switch resourceClass{
        case is XMMContentBlock.Type:
            resourceName = XMMContentBlock.resourceName
        case is XMMContent.Type:
            resourceName = XMMContent.resourceName
        case is XMMSystem.Type:
            resourceName = XMMSystem.resourceName
        case is XMMSystemSettings.Type:
            resourceName = XMMSystemSettings.resourceName
        case is XMMStyle.Type:
            resourceName = XMMStyle.resourceName
        case is XMMMenu.Type:
            resourceName = XMMMenu.resourceName
        case is XMMPushDevice.Type:
            resourceName = XMMPushDevice.resourceName
        case is XMMMarker.Type:
            resourceName = XMMMarker.resourceName
        case is XMMSpot.Type:
            resourceName = XMMSpot.resourceName
        default:
            print("Can finde resource url")
            break
        }
        return baseUrl.appendingPathComponent(resourceName)
    }
    
    func urlWithResource(resourceClass: Any,
                         resourceId: String) -> URL {
        let urlWithResourceName: URL = urlWithResource(resourceClass: resourceClass)
        return urlWithResourceName.appendingPathComponent(resourceId)
    }
    
    func addQueryParametersToUrl(url: URL,
                                 parameters:[String: String]) -> URL {
        var parameterArray: [URLQueryItem] = []
        for key in parameters {
            let name = key.key
            let value = parameters[name]
            parameterArray.append(URLQueryItem(name: name, value: value))
        }
        return addQueryStringToUrl(url: url, queryItems: parameterArray)
    }
    
    func addQueryParameterToUrl(url: URL,
                                name: String,
                                value: String) -> URL {
        return addQueryParametersToUrl(url: url, parameters: [name: value])
    }
    
    func addQueryStringToUrl(url: URL,
                             queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        let url = components?.url
        return url!
    }
}


