//
//  DataToDictionary.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 26.01.2023.
//

import Foundation

extension String {
    func convertDataToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("Conversation error")
            }
        }
        return nil
    }
}
