//
//  File.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 10.02.2023.
//

import Foundation

struct StyleResponse: Codable {
    let data: StyleData?
}


struct StyleData: Codable {
    let id: String?
    let type: String?
    let attributes: StyleAttributes?
}


struct StyleAttributes: Codable {
    let backgroundColor: String?
    let mapPin: String
    let foregroundColor: String?
    let highlightColor: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case backgroundColor = "background-color"
        case mapPin = "map-pin"
        case foregroundColor = "foreground-color"
        case highlightColor = "highlight-color"
        case icon
    }
}
