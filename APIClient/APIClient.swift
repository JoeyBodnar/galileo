//
//  APIClient.swift
//  APIClient
//
//  Created by Stephen Bodnar on 4/29/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

public protocol APIClientDelegate: AnyObject {
    
    func client(_ APIClient: APIClient, didRefreshOAuthToken ressponse: OAuthTokenResponse)
}

final public class APIClient {
    
    public static let shared: APIClient = APIClient()
    
    private let whiteFlower = WhiteFlower()
    
    internal let requestInterceptor: RequestInterceptor = RequestInterceptor()
    
    public var authToken: String? {
        didSet {
            requestInterceptor.authToken = authToken
        }
    }
    
    public var delegate: APIClientDelegate?
    
    public var refreshToken: String?
    
    internal func dataRequest<T: Decodable>(whiteFlowerRequest: WhiteFlowerRequest, forType type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let alteredReqest: WhiteFlowerRequest = requestInterceptor.alteredRequest(fromRequest: whiteFlowerRequest)
        whiteFlower.request(request: alteredReqest) { response in
            switch response.serializeTo(type: T.self) {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                let statusCode: Int = (response.dataTaskResponse?.response as? HTTPURLResponse)?.statusCode ?? 500
                if statusCode == 401 && self.refreshToken != nil {
                    self.refreshToken(originalRequest: whiteFlowerRequest, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    internal func request(whiteFlowerRequest: WhiteFlowerRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let alteredReqest: WhiteFlowerRequest = requestInterceptor.alteredRequest(fromRequest: whiteFlowerRequest)
        whiteFlower.request(request: alteredReqest) { response in
            switch response.isOk() {
            case .success:
                completion(.success(true))
            case .failure(let error):
                let statusCode: Int = (response.dataTaskResponse?.response as? HTTPURLResponse)?.statusCode ?? 500
                if statusCode == 401 && self.refreshToken != nil{
                    self.refreshToken(originalRequest: alteredReqest, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Private
    private func refreshToken<T: Decodable>(originalRequest: WhiteFlowerRequest, completion: @escaping (Result<T, Error>) -> Void) {
        guard let refresh = refreshToken, let authToken = Bundle.main.infoDictionary?["BearerAuthHeader"] as? String else { return }
        whiteFlower.post(urlString: "https://www.reddit.com/api/v1/access_token", params: ["grant_type": "refresh_token", "refresh_token": refresh], headers: [HTTPHeader(field: HTTPHeaderField.contentType, value: HTTPContentType.urlEncoded.rawValue), HTTPHeader(field: HTTPHeaderField.authorization, value: authToken)]) { response in
            switch response.serializeTo(type: OAuthTokenResponse.self) {
            case .success(let oAuthResponse):
                self.delegate?.client(self, didRefreshOAuthToken: oAuthResponse)
                self.authToken = oAuthResponse.accessToken
                self.dataRequest(whiteFlowerRequest: self.requestInterceptor.alteredRequest(fromRequest: originalRequest), forType: T.self, completion: completion)
            case .failure(let error):completion(.failure(error))
            }
        }
    }
}
