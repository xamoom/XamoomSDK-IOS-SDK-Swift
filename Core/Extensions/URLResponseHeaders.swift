//
//  URLResponseHeaders.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 24.01.2023.
//

import Foundation


extension URLResponse {
    func headerField(forKey key: String) -> String? {
        (self as? HTTPURLResponse)?.allHeaderFields[key] as? String
    }
}
