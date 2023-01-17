//
//  XMMPushDevice.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 11.01.2023.
//

import Foundation

class XMMPushDevice: XMMRestResource {
    var resourceName: String {
        return "customer/push-register"
    }
    var model: AnyObject {
        return PushDevice() as AnyObject
    }
    struct PushDevice: Codable {
        
    }
}
