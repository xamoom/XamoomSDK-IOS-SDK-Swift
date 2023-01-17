//
//  XMMMenu.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

class XMMMenu: XMMRestResource{
    var resourceName: String {
        return "consumer/menus"
    }
    var model: AnyObject {
        return Menu() as AnyObject
    }
    struct Menu: Codable {
        
    }
    
}
