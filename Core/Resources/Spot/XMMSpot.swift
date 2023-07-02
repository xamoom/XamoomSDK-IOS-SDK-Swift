//
//  XMMSpot.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * XMMSpot is localized.
 */

public class XMMSpot: XMMRestResource {
    
   static var resourceName: String {
        return "consumer/spots"
    }
    
    // MARK: - Properties
    
    var name: String?
    var spotDescription: String?
    var latitude: Double?
    var longitude: Double?
    var image: String?
    var category: Int?
    var locationDictionary: [String: Any]?
    var tags: [String]?
    var customMeta: [String: Any]?
    var content: XMMContent?
    var markers: [Any]?
    var system: XMMSystem?
}
