//
//  Extensions.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation
import os

// Codable
extension Result where Success == Data? {
    
    /// attempts to parse the data to the given type
    /// fails either when parsing fails or if network request was a failure
    @discardableResult
    public func parse<T: Codable>(type: T.Type, onSuccess: ([T]) -> Void, onError: (Error?) -> Void) -> Result {
        switch self {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([T].self, from: data ?? Data())
                onSuccess(json)
            } catch let error {
                onError(error)
            }
        case .failure(let error):
            onError(error)
        }
        
        return self
    }
    
    /// can safely call and will not be invoked if result is a failure
    /// returns self so we can chain actions
    @discardableResult
    public func parse<T: Codable>(type: T.Type, completion: (Result<T, NetworkError>) -> Void) -> Result {
        if case .success(let data) = self {
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(T.self, from: data ?? Data())
                completion(.success(json))
            } catch let error {
                os_log("parsing error: %@", error.localizedDescription)
                completion(.failure(NetworkError.parseError))
            }
        }
        
        return self
    }
    
    public func parse<T: Codable>(type: T.Type) -> [T]? {
        if case .success(let data) = self {
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([T].self, from: data ?? Data())
                return json
            } catch {
                return nil
            }
        }
        
        return nil
    }
}

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

extension Result {
    // original source for these 2 methods: https://github.com/nsoojin/BookStore/blob/master/BookStore/Extensions/Result%20%2B%20Extensions.swift
    
    /// Will not be invoked if the result failed
    @discardableResult
    public func onSuccess(_ successHandler: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let value) = self {
            successHandler(value)
        }
        
        return self
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
    
    func jsonEncoded() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            return nil
        }
    }
    
    func urlEncoded() -> Data? {
        return self.map { key, value in
            if let keyEncoded = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let valueEncoded = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return keyEncoded + "=" + valueEncoded
            } else {
                return ""
            }
        }.joined(separator: "&").data(using: .utf8)
    }
}
