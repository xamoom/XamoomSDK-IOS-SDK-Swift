//
//  Content.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 10.02.2023.
//

import Foundation


struct ContentResponse : Codable {
    let data : [ContentData]?
    let included : [ContentIncluded]?
    let meta : ContentMeta?
}


struct ContentData : Codable {
    let id : String?
    let type : String?
    let attributes : ContentAttributes?
    let relationships : ContentRelationships?
}


struct ContentAttributes: Codable {
    let languages: [String]?
    let category: Int?
    let description: String?
    let language: String?
    let displayName: String?
    let createdAt: String?
    let customMeta: [CustomMeta]?
    let name: String?
    let tags: [String]?
    let updatedAt: String?
    let coverImageName: String?
    let coverImageURL: String?
    let coverImageCopyright: String?
    let metaDatetimeFrom: String?
    let metaDatetimeTo: String?
    let socialSharingURL: String?
    
    enum CodingKeys: String, CodingKey {
        case languages, category, description, language
        case displayName = "display-name"
        case createdAt = "created-at"
        case customMeta = "custom-meta"
        case name, tags
        case updatedAt = "updated-at"
        case coverImageName = "cover-image-name"
        case coverImageURL = "cover-image-url"
        case coverImageCopyright = "cover-image-copyright"
        case metaDatetimeFrom = "meta-datetime-from"
        case metaDatetimeTo = "meta-datetime-to"
        case socialSharingURL = "social-sharing-url"
    }
}


struct CustomMeta: Codable {
    let key: String?
    let value: String?
}


struct ContentRelationships: Codable {
    let blocks: Blocks?
    let system: System?
    let relatedSpot: RelatedSpot?
    
    enum CodingKeys: String, CodingKey {
        case blocks, system
        case relatedSpot = "related-spot"
    }
}


struct Blocks: Codable {
    let data: [DataStruct]?
}


struct System: Codable {
    let data: DataStruct?
}


struct RelatedSpot: Codable {
    let data: DataStruct?
}


struct DataStruct: Codable {
    let type: String?
    let id: String
}


struct ContentIncluded: Codable {
    let id: String?
    let type: String?
    let attributes: IncludedAttributes?
}


struct IncludedAttributes: Codable {
    let blockType: Int?
    let contentID: String?
    let contentListPageSize: Int?
    let contentListSortAsc: Bool?
    let contentListTags: [String]?
    let isIframeFullscreen: Bool?
    let isPublic: Bool?
    let showElevation: Bool?
    let shouldShowContentOnSpotmap: Bool?
    let spotMapTags: [String]?
    let altText: String?
    let artists: String?
    let copyright: String?
    let soundcloudURL: String?
    let text: String?
    let title: String?
    let videoURL: String?
    let linkType: Int?
    let linkURL: String?
    let fileID: String?
    let scaleX: Double?
    let downloadType: Int?
    
    enum CodingKeys: String, CodingKey {
        case blockType = "block-type"
        case contentID = "content-id"
        case contentListPageSize = "content-list-page-size"
        case contentListSortAsc = "content-list-sort-asc"
        case contentListTags = "content-list-tags"
        case isIframeFullscreen = "is-iframe-fullscreen"
        case isPublic = "is-public"
        case showElevation = "show-elevation"
        case shouldShowContentOnSpotmap = "should-show-content-on-spotmap"
        case spotMapTags = "spot-map-tags"
        case altText = "alt-text"
        case artists, copyright
        case soundcloudURL = "soundcloud-url"
        case text, title
        case videoURL = "video-url"
        case linkType = "link-type"
        case linkURL = "link-url"
        case fileID = "file-id"
        case scaleX = "scale-x"
        case downloadType = "download-type"
    }
}


struct ContentMeta: Codable {
    let cursor: String?
    let hasMore: Bool?
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case cursor
        case hasMore = "has-more"
        case total
    }
}


