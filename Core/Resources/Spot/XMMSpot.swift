//
//  XMMSpot.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

public struct XMMSpot: XMMRestResource, Codable {
    
   static var resourceName: String {
        return "consumer/spots"
    }
}
