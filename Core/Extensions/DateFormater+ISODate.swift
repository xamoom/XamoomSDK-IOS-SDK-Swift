//
//  DateFormater+ISODate.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 18.01.2023.
//

import Foundation


extension DateFormatter {
    func ISO8601Formatter() -> DateFormatter {
        let iso8601Formatter = DateFormatter()
            iso8601Formatter.timeZone = .init(abbreviation: "UTC")
            iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return iso8601Formatter
    }
}
