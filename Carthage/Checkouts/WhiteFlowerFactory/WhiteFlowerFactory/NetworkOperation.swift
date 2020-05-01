//
//  NetworkOperation.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation
import os

internal final class NetworkOperation : AsynchronousOperation {
    var task: URLSessionTask?
    
    init(request: WhiteFlowerRequest, completion: @escaping(DataTaskCompletion)) {
        super.init()
        
        guard let urlRequest = request.urlRequest else {
            completion(APIResponse(dataTaskResponse: nil, result: .failure(.invalidURL(400)), originalRequest: nil))
            cancel()
            return
        }
        
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            defer { self.finish() }
            os_log("finished")
            let apiResponse = APIResponse(data: data, response: response, error: error, originalRequest: urlRequest)
            completion(apiResponse)
        })
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    override func main() {
        task?.resume()
        os_log("starting")
    }
}
