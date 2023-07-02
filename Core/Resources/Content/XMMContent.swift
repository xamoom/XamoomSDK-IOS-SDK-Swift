//
//  XMMContent.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * XMMContent is localized and containts the different blocks saved
 * in contentBlocks.
 */

public class XMMContent: XMMRestResource {
    
    static var resourceName: String {
         return "consumer/contents"
     }
    
    // MARK: - Properties
    
    var title: String?
    var imagePublicUrl: String?
    var contentDescription: String?
    var language: String?
    var contentBlocks: [XMMContentBlock]?
    var category: Int?
    var tags: [Any]?
    var customMeta: [String: Any]?
    var system: XMMSystem?
    var spot: XMMSpot?
    var sharingUrl: String?
    var relatedSpot: XMMSpot?
    var toDate: Date?
    var fromeDate: Date?
    var coverImageCopyRight: String?
    
    
    init(_ content: ContentResponse){
        let atributes = mapContentAtributes(content)
        
    }
    
    func mapContentAtributes(_ content: ContentResponse) -> IncludedAttributes {
        var contentAttributes: IncludedAttributes?
        contentAttributes = content.included?.first?.attributes
        
        print (contentAttributes)
        return contentAttributes!
    }
    
   
   
    
    
}
