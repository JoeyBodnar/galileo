//
//  WhiteFlowerSerialQueue.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

/// Used for creating a queue of network requests to be ran serially
public final class WhiteFlowerSerialQueue {
    public var operationQueue: OperationQueue
    
    var responses = [APIResponse]()
    
    public init(operationQueue: OperationQueue = OperationQueue()) {
        self.operationQueue = operationQueue
        self.operationQueue.maxConcurrentOperationCount = 1
    }
    
    /// Do not directly call this outside of this class.
    private func addOperations(operations: [Operation]) {
        for operation in operations {
            operationQueue.addOperation(operation)
        }
    }
    
    /// Begins performing the WhiteFlowerRequests 1 by 1.
    /// operationCompletion is called after every individual request finishes.
    /// completion is called only after all requests are finiished.
    public func start(requests: [WhiteFlowerRequest], operationCompletion: @escaping(DataTaskCompletion), completion: @escaping ([APIResponse]) -> Void) {
        let operations = requests.map { (request) -> NetworkOperation in
            return NetworkOperation(request: request) { response in
                self.responses.append(response)
                operationCompletion(response)
            }
        }
        addOperations(operations: operations)
        
        let endOperation = BlockOperation {
            completion(self.responses)
        }
        for i in operations { endOperation.addDependency(i) }
        
        operationQueue.addOperation(endOperation)
    }
}
