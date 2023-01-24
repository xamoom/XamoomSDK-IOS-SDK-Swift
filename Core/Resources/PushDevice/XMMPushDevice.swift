//
//  XMMPushDevice.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 11.01.2023.
//

import Foundation

public struct XMMPushDevice: XMMRestResource, Codable {
    
    static var resourceName: String {
        return "customer/push-register"
    }
}
