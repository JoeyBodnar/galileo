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
    
    func client(_ APIClient: APIClient, didRefreshOAuthToken response: OAuthTokenResponse)
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
        whiteFlower.request(request: alteredReqest) { [weak self] response in
            switch response.serializeTo(type: T.self) {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                let statusCode: Int = (response.dataTaskResponse?.response as? HTTPURLResponse)?.statusCode ?? 500
                if statusCode == 401 && self?.refreshToken != nil {
                    self?.refreshToken(originalRequest: whiteFlowerRequest, forType: type, isDataRequest: true, dataCompletion: completion, okCompletion: nil)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    internal func request(whiteFlowerRequest: WhiteFlowerRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let alteredReqest: WhiteFlowerRequest = requestInterceptor.alteredRequest(fromRequest: whiteFlowerRequest)
        whiteFlower.request(request: alteredReqest) { [weak self] response in
            switch response.isOk() {
            case .success:
                completion(.success(true))
            case .failure(let error):
                let statusCode: Int = (response.dataTaskResponse?.response as? HTTPURLResponse)?.statusCode ?? 500
                if statusCode == 401 && self?.refreshToken != nil{
                    self?.refreshToken(originalRequest: whiteFlowerRequest, forType: Bool.self, isDataRequest: false, dataCompletion: nil, okCompletion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Private
    private func refreshToken<T: Decodable>(originalRequest: WhiteFlowerRequest, forType type: T.Type, isDataRequest: Bool, dataCompletion: ((Result<T, Error>) -> Void)?, okCompletion: ((Result<Bool, Error>) -> Void)?) {
        guard let refresh = refreshToken, let authToken = ProcessInfo.processInfo.environment["BEARER_AUTH_HEADER"] else { return }
        whiteFlower.post(urlString: "https://www.reddit.com/api/v1/access_token", params: ["grant_type": "refresh_token", "refresh_token": refresh], headers: [HTTPHeader(field: HTTPHeaderField.contentType, value: HTTPContentType.urlEncoded.rawValue), HTTPHeader(field: HTTPHeaderField.authorization, value: authToken)]) { [weak self] response in
            guard let weakSelf = self else { return }
            switch response.serializeTo(type: OAuthTokenResponse.self) {
            case .success(let oAuthResponse):
                weakSelf.delegate?.client(weakSelf, didRefreshOAuthToken: oAuthResponse)
                weakSelf.authToken = oAuthResponse.accessToken
                if isDataRequest, let completion = dataCompletion {
                    weakSelf.dataRequest(whiteFlowerRequest: weakSelf.requestInterceptor.alteredRequest(fromRequest: originalRequest), forType: type, completion: completion)
                } else if let completion = okCompletion {
                    weakSelf.request(whiteFlowerRequest: weakSelf.requestInterceptor.alteredRequest(fromRequest: originalRequest), completion: completion)
                }
            case .failure(let error):
                if isDataRequest {
                    dataCompletion?(.failure(error))
                } else {
                    okCompletion?(.failure(error))
                }
            }
        }
    }
}
