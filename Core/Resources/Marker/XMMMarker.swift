//
//  XMMMarker.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMMarker: XMMRestResource {
    var resourceName: String {
        return "markers"
    }
    var model: AnyObject {
        return Marker() as AnyObject
    }
    struct Marker: Codable {
        
    }
}
