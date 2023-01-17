//
//  XMMSpot.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMSpot: XMMRestResource {
    var resourceName: String {
        return "consumer/spots"
    }
    var model: AnyObject {
        return Spot() as AnyObject
    }
    struct Spot: Codable {
        
    }
    
    
}
