//
//  XMMStyle.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 26.01.2023.
//

import Foundation

/**
 * XMMStyle with colors and icons.
 */

public class XMMStyle: XMMRestResource {
    
   static var resourceName: String {
        return "consumer/styles"
    }
    
    //MARK: - Properties
    
    var backgroundColor: String?
    var highlightFontColor: String?
    var foregroundFontColor: String?
    var chromeHeaderColor: String?
    var customMarker: String?
    var icon: String?
}
