//
//  XMMEnduserApi.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

public struct XMMSystemSettings: XMMRestResource, Codable {
    static var resourceName: String {
        return "consumer/settings"
    }
}
