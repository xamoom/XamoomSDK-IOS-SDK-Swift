//
//  System.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 10.02.2023.
//

import Foundation

struct SystemResponse: Codable {
    let data: SystemResponseData?
}


struct SystemResponseData: Codable {
    let id: String?
    let type: String?
    let attributes: SystemAttributes?
    let relationships: SystemRelationships?
}


struct SystemAttributes: Codable {
    let isDemo: Bool?
    let language: String?
    let isPushEnabled: Bool?
    let displayName: String?
    let url: String?
    let webClientURL: String?

    enum CodingKeys: String, CodingKey {
        case isDemo = "is-demo"
        case language
        case isPushEnabled = "is-push-enabled"
        case displayName = "display-name"
        case url
        case webClientURL = "web-client-url"
    }
}

struct SystemRelationships: Codable {
    let frontendConfigs: SystemRelationshipsData?
    let menu: SystemRelationshipsData?
    let setting: SystemRelationshipsData?
    let style: SystemRelationshipsData?
}


struct SystemRelationshipsData: Codable {
    let type: String?
    let id: String?
}
