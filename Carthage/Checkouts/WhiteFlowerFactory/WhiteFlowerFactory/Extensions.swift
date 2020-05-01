//
//  Extensions.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation
import os

extension Result where Success == Data? {
    
    /// Used when you expect your returned data to just be a string
    public func stringValue() -> String? {
        switch self {
        case .success(let data):
            guard let unwrappedData = data else { return nil }
            return String(data: unwrappedData, encoding: String.Encoding.utf8)
        case .failure:
            return nil
        }
    }
}

extension Array where Element == HTTPHeader {
    
    internal var containsUrlEncoded: Bool {
        return self.contains { $0.value == HTTPContentType.urlEncoded.rawValue }
    }
    
    /// array of HTTPHeader objects ina  single dictionary
    internal var allAsDictionary: [String: String] {
        var dictionary: [String: String] = [:]
        for header in self {
            dictionary[header.field] = header.value
        }
        
        return dictionary
    }
}

extension Dictionary where Key == String, Value == Any {
    
    internal func jsonEncoded() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            return nil
        }
    }
    
    internal func urlEncoded() -> Data? {
        return self.map { key, value in
            if let keyEncoded = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let valueEncoded = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return keyEncoded + "=" + valueEncoded
            } else {
                return ""
            }
        }.joined(separator: "&").data(using: .utf8)
    }
}
