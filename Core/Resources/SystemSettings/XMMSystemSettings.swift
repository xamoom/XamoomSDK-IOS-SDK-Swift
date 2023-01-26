//
//  File.swift
//  XamoomSDK
//
//  Created by Иван Магда on 26.01.2023.
//

import Foundation

public struct XMMSystemSettings: XMMRestResource, Codable {
    static var resourceName: String {
        return "consumer/settings"
    }
}
