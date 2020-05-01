//
//  SessionManager.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/20/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

final class SessionManager {
    
    static let shared: SessionManager = SessionManager()
    
    var isLoggedIn: Bool {
        return DefaultsManager.shared.userAuthorizationToken != nil
    }
}
