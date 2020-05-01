//
//  HTTPBinGetResponse.swift
//  WhiteFlowerFactoryTests
//
//  Created by Stephen Bodnar on 4/7/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

/// Format is below:
///{
  ///"args": {},
  ///"headers": {
  /// "Accept": "application/json",
  /// "Accept-Encoding": "gzip, deflate, br",
  /// "Accept-Language": "en-us",
 ///  "Host": "httpbin.org",
  /// "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/xxx.xx.x"
  ///},
///"origin": "xxipaddressxx",
///"url": "https://httpbin.org/get"
///}

struct HTTPBinGetResponse: Decodable {
    let url: String
    let origin: String
    let headers: HTTPBinGetResponseHeaders
}

struct HTTPBinGetResponseHeaders: Decodable {
    let accept: String
    let host: String
    
    enum CodingKeys: String, CodingKey {
        case accept = "Accept"
        case host = "Host"
    }
}
