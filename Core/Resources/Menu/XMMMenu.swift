//
//  XMMMenu.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * XMMMenu with the menuItems.
 */

public class XMMMenu: XMMRestResource {
    
    static var resourceName: String {
        return "consumer/menus"
    }
    
    // MARK: - Properties
    
    var items: [Any]?
    
}
