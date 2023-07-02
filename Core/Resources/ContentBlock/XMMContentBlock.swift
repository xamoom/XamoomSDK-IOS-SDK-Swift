//
//  XMMContentBlock.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * XMMContentBlock can have 16 different types (see blockType).
 * Every contentBlock are localized and only uses some of the properties.
 */

public class XMMContentBlock: XMMRestResource {
    
   static var resourceName: String {
        return "contentblocks"
    }
    
    // MARK: - Properties
    
    var title: String?
    var publicStatus: Bool?
    var blockType: Int?
    var text: String?
    var artists: String?
    var fileID: String?
    var soundCloudUrl: String?
    var linkType: Int?
    var linkUrl: String?
    var contentID: String?
    var downloadType: Int?
    var spotMapTags: [String]?
    var scaleX: Double?
    var videoUrl: String?
    var showContent: Bool?
    var altText: String?
    var copyright: String?
    var contentListTags: [String]?
    var contentListPageSize: Int?
    var contentListSortAsc: Bool?
    var showElevation: Bool?
    var iframeUrl: String?
    var fullScreen: Bool? 
}
