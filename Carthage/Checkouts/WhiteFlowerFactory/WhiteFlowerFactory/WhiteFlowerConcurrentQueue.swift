//
//  WhiteFlowerConcurrentQueue.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 4/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

public final class WhiteFlowerConcurrentQueue {
    
    private let requests: [WhiteFlowerRequest]
    private let queue: DispatchQueue
    
    /// if `true`, then the order of the array of the responses will be in the same order as the original requests
    public var maintainOrder: Bool = true
    
    /// array of responses to send back
    private var responses: [APIResponse] = []
    
    /// the original URLRequest objects for the `requests`. Will filter out nil items.
    private var originalURLRequests: [URLRequest] {
        return requests.compactMap { whiteFlowerReqest -> URLRequest? in
            return whiteFlowerReqest.urlRequest
        }
    }
    
    public init(requests: [WhiteFlowerRequest], queue: DispatchQueue) {
        self.requests = requests
        self.queue = queue
    }
    
    public func execute(completion: @escaping (_ responses: [APIResponse]) -> Void) {
        let group: DispatchGroup = DispatchGroup()
        
        for request in requests {
            group.enter()
            WhiteFlower.shared.request(request: request) { response in
                self.responses.append(response)
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            if self.maintainOrder {
                self.responses = self.setResponsesToOriginalOrder(responses: self.responses)
            }
            self.queue.async {
                completion(self.responses)
            }
        }
    }
    
    internal func setResponsesToOriginalOrder(responses: [APIResponse]) -> [APIResponse] {
        return responses.sorted { response1, response2 -> Bool in
            if let response1OriginalUrlrequest = response1.originalRequest, let response1IndexinOriginal = originalURLRequests.firstIndex(of: response1OriginalUrlrequest), let response2OriginalUrlrequest = response2.originalRequest, let response2IndexinOriginal = originalURLRequests.firstIndex(of: response2OriginalUrlrequest) {
                
                return response1IndexinOriginal < response2IndexinOriginal
            } else {
                return false
            }
        }
    }
}
