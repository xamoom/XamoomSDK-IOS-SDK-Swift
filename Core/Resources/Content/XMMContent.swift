//
//  XMMContent.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

public class XMMContent: XMMRestResource, Codable {
    
    var title: String?
    var contentDescription: String?
    var imagePublicUrl: String?
    var language: String?
    var category: String?
    var tagsa: String?
    var customMetaArray: String?
    var sharindUrl: String?
    var toDate: String?
    var fromeDate: String?
    var system: XMMSystem?
    var spot: XMMSpot?
    var relatedSpot: XMMSpot?
    var contentBlocks: XMMContentBlock?
    var coverImageCopyRight: String?
    
    
    init(_ content: ContentResponse){
    }
    
   static var resourceName: String {
        return "consumer/contents"
    }
   
    
    
}
