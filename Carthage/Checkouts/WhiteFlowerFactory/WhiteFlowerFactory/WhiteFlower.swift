//
//  APIRequest.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/13/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

public typealias DataTaskCompletion = (APIResponse) -> Void

public final class WhiteFlower {
    
    public static let shared = WhiteFlower()
    
    /// the URLSession to be used with this instance of WhiteFlower. Default is URLSession.shared
    internal let session: URLSession
    
    /// the queue where to receive callbacks. default is DispatchQueue.main
    internal let dispatchQueue: DispatchQueue
    
    public init(session: URLSession = URLSession.shared, dispatchQueue: DispatchQueue = .main) {
        self.session = session
        self.dispatchQueue = dispatchQueue
    }
    
    /// All individual requests are routed through here. the only requests that are not routed through this function are the
    /// requests executed by a WhiteFlowerSerialQueue
    private func request(_ method: HTTPMethod, withURL urlString: String, withParams params: [String: Any]?, andHeaders headers: [HTTPHeader]?, completion: @escaping(DataTaskCompletion)) {
        guard let _ = URL(string: urlString) else {
            completion(APIResponse(dataTaskResponse: nil, result: .failure(NetworkError.invalidURL(400)), originalRequest: nil))

            return
        }
        
        let whiteFlowerRequest = WhiteFlowerRequest(method: method, urlString: urlString)
        whiteFlowerRequest.params = params
        whiteFlowerRequest.headers = headers
        
        guard let request = whiteFlowerRequest.urlRequest else {
            return
        }
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.dispatchQueue.async {
                completion(APIResponse(data: data, response: response, error: error, originalRequest: request))
            }
        }
        
        task.resume()
    }
    
}

// Convenience functions
extension WhiteFlower {
    
    public func request(request: WhiteFlowerRequest, completion: @escaping(DataTaskCompletion)) {
        self.request(request.method, withURL: request.urlString, withParams: request.params, andHeaders: request.headers, completion: completion)
    }
    
    public func get(request: WhiteFlowerRequest, completion: @escaping(DataTaskCompletion)) {
        self.request(request.method, withURL: request.urlString, withParams: request.params, andHeaders: request.headers, completion: completion)
     }
     
     public func get<T: Provider>(endPoint: T, headers: [HTTPHeader]? = nil, completion: @escaping(DataTaskCompletion)) {
        request(.get, withURL: endPoint.path, withParams: nil, andHeaders: headers, completion: completion)
     }
     
     public func get(urlString: String, headers: [HTTPHeader]? = nil, completion: @escaping(DataTaskCompletion)) {
        request(.get, withURL: urlString, withParams: nil, andHeaders: nil, completion: completion)
     }
     
     public func post<T: Provider>(endPoint: T, params: [String: Any], headers: [HTTPHeader], completion: @escaping(DataTaskCompletion)) {
        request(.post, withURL: endPoint.path, withParams: params, andHeaders: headers, completion: completion)
     }
     
     public func post(urlString: String, params: [String: Any], headers: [HTTPHeader], completion: @escaping(DataTaskCompletion)) {
        request(.post, withURL: urlString, withParams: params, andHeaders: headers, completion: completion)
     }
     
     public func put<T: Provider>(endPoint: T, params: [String: Any], headers: [HTTPHeader], completion: @escaping(DataTaskCompletion)) {
        request(.put, withURL: endPoint.path, withParams: params, andHeaders: headers, completion: completion)
     }
     
     public func put(urlString: String, params: [String: Any], headers: [HTTPHeader], completion: @escaping(DataTaskCompletion)) {
        request(.put, withURL: urlString, withParams: params, andHeaders: headers, completion: completion)
     }
     
     public func delete<T: Provider>(endPoint: T, params: [String: Any], headers: [HTTPHeader], completion: @escaping(DataTaskCompletion)) {
        request(.delete, withURL: endPoint.path, withParams: params, andHeaders: headers, completion: completion)
     }
     
     public func delete(urlString: String, params: [String: Any], headers: [HTTPHeader], completion: @escaping(DataTaskCompletion)) {
        request(.delete, withURL: urlString, withParams: params, andHeaders: headers, completion: completion)
     }
}
