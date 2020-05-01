//
//  WhiteFlowerConcurrentQueueTests.swift
//  WhiteFlowerFactoryTests
//
//  Created by Stephen Bodnar on 4/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import XCTest

class WhiteFlowerConcurrentQueueTests: XCTestCase {
    
    func testResetsOriginalOrder() {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, urlString: "https://httpbin.org/get")
        let request2: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, urlString: "https://www.apple.com")
        let request3: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, urlString: "https://www.yahoo.com")
        let request4: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, urlString: "https://www.reddit.com")
        
        let requests = [request, request2, request3, request4]
        
        let queue = WhiteFlowerConcurrentQueue(requests: requests, queue: .main)
        
        let shuffledResponses = requests.map { wfRequest -> APIResponse in
            return APIResponse(dataTaskResponse: nil, result: .success(nil), originalRequest: wfRequest.urlRequest)
        }.shuffled()
        
        let resetResponses = queue.setResponsesToOriginalOrder(responses: shuffledResponses)
        
        XCTAssertTrue(resetResponses[0].originalRequest!.url!.absoluteString == "https://httpbin.org/get")
        XCTAssertTrue(resetResponses[1].originalRequest!.url!.absoluteString == "https://www.apple.com")
        XCTAssertTrue(resetResponses[2].originalRequest!.url!.absoluteString == "https://www.yahoo.com")
        XCTAssertTrue(resetResponses[3].originalRequest!.url!.absoluteString == "https://www.reddit.com")
    }
}
