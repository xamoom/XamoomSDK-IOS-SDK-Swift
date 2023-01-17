//
//  XMMContent.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMContent: XMMRestResource{
    
    var resourceName: String {
        return "consumer/contents"
    }
    var model: AnyObject {
        return Content() as AnyObject
    }
    struct Content: Codable {
        
    }
    
    
}
