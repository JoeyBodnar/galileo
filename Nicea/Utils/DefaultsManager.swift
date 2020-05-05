//
//  DefaltsManager.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

class DefaultsManager {
    
    static let shared: DefaultsManager = DefaultsManager()
    
    private struct Keys {
        static let userAuthorizationToken: String = "userAuthorizationToken"
        static let userRefreshToken: String = "userRefreshToken"
    }
    
    var userAuthorizationToken: String? {
        get {
            return UserDefaults.standard.value(forKey: Keys.userAuthorizationToken) as? String
        } set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Keys.userAuthorizationToken)
            } else {
                UserDefaults.standard.set(newValue, forKey: Keys.userAuthorizationToken)
            }
        }
    }
    
    var userRefreshToken: String? {
        get {
            return UserDefaults.standard.value(forKey: Keys.userRefreshToken) as? String
        } set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Keys.userRefreshToken)
            } else {
                UserDefaults.standard.set(newValue, forKey: Keys.userRefreshToken)
            }
        }
    }
}
