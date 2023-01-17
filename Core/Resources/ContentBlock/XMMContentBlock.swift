//
//  XMMContentBlock.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMContentBlock: XMMRestResource {
    
    var resourceName: String {
        return "contentblocks"
    }
    
    var model: AnyObject {
        return ContentBlock() as AnyObject
    }
    
    struct ContentBlock: Codable {
        
    }
    
    
}
