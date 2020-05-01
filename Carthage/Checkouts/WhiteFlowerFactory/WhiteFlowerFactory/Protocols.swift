//
//  Protocols.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

/// Represents an object that can provide a valid URL path via the path property
/// Ideally it should be used with an enum to provide easy typpe safe routing
/// You can have as many Providers in your app as you want. It is good to have
/// one provider for each baseURl/service your app uses (Facebook API, Google API, Stripe, etc)
/// Here is a sample implementation:
//    enum Facebook: Provider {
//        case login
//
//        var path: String {
//            switch self {
//            case .login: return "\(baseURL)/login"
//            }
//        }
//
//        var baseURL: String {
//            return "https://facebook.com"
//        }
//
//        static var name: String {
//            return String(describing: Facebook.self) // this returns "Facebook"
//        }
//    }

public protocol Provider {
    var path: String { get }
    var baseURL: String { get }
    static var name: String { get }
}

