//
//  WhiteFlowerRequestTests.swift
//  WhiteFlowerFactoryTests
//
//  Created by Stephen Bodnar on 4/7/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import XCTest

class WhiteFlowerRequestTests: XCTestCase {
    
    func testWhiteFlowerRequestPassesCorrectUrlString() {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, urlString: "https://www.httpbin.org")
        
        let urlRequest: URLRequest = request.urlRequest!
        
        XCTAssertTrue(urlRequest.url!.absoluteString == "https://www.httpbin.org")
    }
    
    func testWhiteFlowerRequestPassesCorrectHttpMethod() {
        let requestTypes: [HTTPMethod] = [.get, .post, .delete, .put, .patch, .options, .head]
        
        for requestType in requestTypes {
            let request: WhiteFlowerRequest = WhiteFlowerRequest(method: requestType, urlString: "https://www.httpbin.org")
            
            let urlRequest: URLRequest = request.urlRequest!
            
            switch requestType {
            case .get: XCTAssertTrue(urlRequest.httpMethod! == "GET")
            case .post: XCTAssertTrue(urlRequest.httpMethod! == "POST")
            case .delete: XCTAssertTrue(urlRequest.httpMethod! == "DELETE")
            case .put: XCTAssertTrue(urlRequest.httpMethod! == "PUT")
            case .patch: XCTAssertTrue(urlRequest.httpMethod! == "PATCH")
            case .options: XCTAssertTrue(urlRequest.httpMethod! == "OPTIONS")
            case .head: XCTAssertTrue(urlRequest.httpMethod! == "HEAD")
            }
        }
    }
    
    func testWhiteFlowerRequestPassesHTTPHeaders() {
        let authHeader: HTTPHeader = HTTPHeader(field: HTTPHeaderField.authorization, value: "Authorization 123")
        let agentHeader: HTTPHeader = HTTPHeader(field: HTTPHeaderField.userAgent, value: "macbook")
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: MockProvider.url, headers: [authHeader, agentHeader])
        
        let headerFields: [String: String] = request.urlRequest!.allHTTPHeaderFields!
        XCTAssertTrue(headerFields["Authorization"] == "Authorization 123")
        XCTAssertTrue(headerFields["User-Agent"] == "macbook")
        
        let anotherRequest: WhiteFlowerRequest = WhiteFlowerRequest(method: .patch, endPoint: MockProvider.url, params: nil, headers: [authHeader])
        let anotherRequestHeaderFields: [String: String] = anotherRequest.urlRequest!.allHTTPHeaderFields!
        XCTAssertTrue(anotherRequestHeaderFields["Authorization"] == "Authorization 123")
        XCTAssertTrue(anotherRequestHeaderFields["User-Agent"] == nil)
        
        // assert headers go through with empty params
        let postRequest: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: MockProvider.url, params: nil, headers: [authHeader, agentHeader])
        let postRequestHeaderFields: [String: String] = postRequest.urlRequest!.allHTTPHeaderFields!
        XCTAssertTrue(postRequestHeaderFields["Authorization"] == "Authorization 123")
        XCTAssertTrue(postRequestHeaderFields["User-Agent"] == "macbook")
        
        // assert headers go through with params present
        let postRequest2: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: MockProvider.url, params: ["email": "email123@gmail.com"], headers: [authHeader, agentHeader])
        let postRequestHeaderFields2: [String: String] = postRequest2.urlRequest!.allHTTPHeaderFields!
        XCTAssertTrue(postRequestHeaderFields2["Authorization"] == "Authorization 123")
        XCTAssertTrue(postRequestHeaderFields2["User-Agent"] == "macbook")
    }
    
    func testJSONIsDefaultContentTypeHeaderForPost() {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: MockProvider.url, params: ["email": "email123@gmail.com"])
        let headerFields: [String: String] = request.urlRequest!.allHTTPHeaderFields!
        XCTAssertTrue(headerFields["Content-Type"] == "application/json")
        
        let getRequest: WhiteFlowerRequest = WhiteFlowerRequest(method: .get, endPoint: MockProvider.url)
        XCTAssertTrue(getRequest.urlRequest!.allHTTPHeaderFields!["Content-Type"] == nil)
    }
    
    func testWhiteFlowerRequestPassesContentType() {
        let contentTypes: [HTTPContentType] = [.gif, .jpeg, .json, .png, .urlEncoded, .xml, .textPlain, .mp4]
        
        for type in contentTypes {
            let postRequest: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: MockProvider.url, headers: [HTTPHeader(field: HTTPHeaderField.contentType, value: type.rawValue)])
            
            let contentType: String = postRequest.urlRequest!.allHTTPHeaderFields!["Content-Type"]!
            switch type {
            case .gif: XCTAssertTrue(contentType == "image/gif")
            case .jpeg: XCTAssertTrue(contentType == "image/jpeg")
            case .json: XCTAssertTrue(contentType == "application/json")
            case .png: XCTAssertTrue(contentType == "image/png")
            case .urlEncoded: XCTAssertTrue(contentType == "application/x-www-form-urlencoded")
            case .xml: XCTAssertTrue(contentType == "text/xml")
            case .textPlain: XCTAssertTrue(contentType == "text/plain")
            case .mp4: XCTAssertTrue(contentType == "video/mp4")
            }
        }
    }
    
    func testWhiteFlowerReqestPassesParameters() {
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: MockProvider.url, params: ["param1": "value1", "param2": 2], headers: nil)
        
        let httpBody = request.urlRequest!.httpBody!
        
        let json: [String: Any] = try! JSONSerialization.jsonObject(with: httpBody, options: .fragmentsAllowed) as! [String: Any]
        XCTAssertTrue((json["param1"] as! String) == "value1")
        XCTAssertTrue((json["param2"] as! Int) == 2)
    }
}
