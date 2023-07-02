//
//  File.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 10.02.2023.
//

import Foundation

struct SpotResponse: Codable {
    let data: [SpotData]?
    let meta: SpotMeta?
}


struct SpotData: Codable {
    let id, type: String?
    let attributes: SpotAttributes?
    let relationships: SpotRelationships?
}


struct SpotAttributes: Codable {
    let name: String?
    let description: String?
    let category: Int?
    let image: String?
    let tags: [String]?
    let location: Location?
    let customMeta: [SpotCustomMeta]?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case name, description, category, image, tags, location
        case customMeta = "custom-meta"
        case createdAt = "created-at"
        case updatedAt = "updated-at"
    }
}


struct SpotCustomMeta: Codable {
    let key: String?
    let value: String?
}


struct Location: Codable {
    let lat: Double?
    let lon: Double?
}


struct SpotRelationships: Codable {
    let content: SpotRelationshipsData?
    let system: SpotRelationshipsData?
}


struct SpotRelationshipsData: Codable {
    let id: String?
    let type: String?
}


struct SpotMeta: Codable {
    let cursor: String?
    let cursors: [String]?
    let hasMore: Bool?
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case cursor, cursors
        case hasMore = "has-more"
        case total
    }
}



