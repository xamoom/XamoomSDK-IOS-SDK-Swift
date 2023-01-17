//
//  XMMRestResource.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 11.01.2023.
//

import Foundation

protocol XMMRestResource {
    var resourceName: String { get }
    
    var model: AnyObject { get }
}
