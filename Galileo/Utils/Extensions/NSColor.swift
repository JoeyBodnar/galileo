//
//  UIColor.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/24/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

extension NSColor {
    
    class func fromHexString(hex: String, alpha: Float) -> NSColor? {
        // Handle two types of literals: 0x and # prefixed
        var cleanedString = ""
        if hex.hasPrefix("0x") {
            cleanedString = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
        } else if hex.hasPrefix("#") {
            cleanedString = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
        }
        // Ensure it only contains valid hex characters 0
        let validHexPattern = "[a-fA-F0-9]+"
        
        if cleanedString.conformsTo(pattern: validHexPattern) {
            var theInt: UInt32 = 0
            let scanner = Scanner(string: cleanedString)
            scanner.scanHexInt32(&theInt)
            let red = CGFloat((theInt & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((theInt & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((theInt & 0xFF)) / 255.0
            return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    
        } else {
            return nil
        }
    }
}
