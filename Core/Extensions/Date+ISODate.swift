//
//  Date+ISODate.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 18.01.2023.
//

import Foundation


extension Date {
    
    func ISO8601() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .init(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter.string(from: self as Date)
    }
}
