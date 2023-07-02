//
//  System.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * XMMSystem with linked XMMSystemSettings, XMMStyle and XMMMenu.
 */

public class XMMSystem: XMMRestResource {
    
    static var resourceName: String {
        return "consumer/systems"
    }
    
    // MARK: - Properties
    
    let name: String? = nil
    let url: String? = nil
    let webClientUrl: String? = nil
    let settings: XMMSystemSettings? = nil
    let style: XMMStyle? = nil
    let menu: XMMMenu? = nil
}
