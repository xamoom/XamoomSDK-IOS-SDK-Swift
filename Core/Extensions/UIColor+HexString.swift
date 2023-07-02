//
//  UIColor+HexString.swift
//  XamoomSDK
//
//  Created by Ivan Magda on 01.05.2023.
//

import Foundation

extension UIColor {
    convenience init?(hexString: String) {
        let colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        var alpha: CGFloat = 0.0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        switch colorString.count {
        case 3: // #RGB
            red = Self.colorComponent(from: colorString, start: 0, length: 1)
            green = Self.colorComponent(from: colorString, start: 1, length: 1)
            blue = Self.colorComponent(from: colorString, start: 2, length: 1)
        case 4:
            alpha = Self.colorComponent(from: colorString, start: 0, length: 1)
            red = Self.colorComponent(from: colorString, start: 1, length: 1)
            green = Self.colorComponent(from: colorString, start: 2, length: 1)
            blue = Self.colorComponent(from: colorString, start: 3, length: 1)
        case 6:
            red = Self.colorComponent(from: colorString, start: 0, length: 2)
            green = Self.colorComponent(from: colorString, start: 2, length: 2)
            blue = Self.colorComponent(from: colorString, start: 4, length: 2)
        case 8:
            alpha = Self.colorComponent(from: colorString, start: 0, length: 2)
            red = Self.colorComponent(from: colorString, start: 2, length: 2)
            green = Self.colorComponent(from: colorString, start: 4, length: 2)
            blue = Self.colorComponent(from: colorString, start: 6, length: 2)
        default:
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private static func colorComponent(from string: String, start: Int, length: Int) -> CGFloat {
        let startIndex = string.index(string.startIndex, offsetBy: start)
        let endIndex = string.index(string.startIndex, offsetBy: length)
        let substring = String(string[startIndex..<endIndex])
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent: UInt32 = 0
        guard Scanner(string: fullHex).scanHexInt32(&hexComponent) else {
            return 0
        }
        return CGFloat(hexComponent) / 255.0
    }
}
