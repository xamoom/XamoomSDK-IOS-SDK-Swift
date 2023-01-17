//
//  System.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation
class XMMSystem: XMMRestResource {
    var resourceName: String {
        return "consumer/systems"
    }
    var model: AnyObject {
        return System() as AnyObject
    }
    struct System: Codable {
        
    }
}
