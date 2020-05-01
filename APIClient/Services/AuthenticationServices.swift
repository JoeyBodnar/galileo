//
//  AuthenticationServices.swift
//  APIClient
//
//  Created by Stephen Bodnar on 3/26/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import WhiteFlowerFactory

public class AuthenticationServices {
    
    public static let shared = AuthenticationServices()
    
    public func retrieveToken(code: String, authHeader: String, completion: @escaping (Result<OAuthTokenResponse, Error>) -> Void) {
        let endpoint: AuthenticationRouter = AuthenticationRouter.getToken
        let params: [String: String] = ["grant_type": "authorization_code", "code": code, "redirect_uri": "https://www.vaporforums.io"]
        let headers: [HTTPHeader] = [HTTPHeader(field: HTTPHeaderField.authorization, value: authHeader)]
        let request: WhiteFlowerRequest = WhiteFlowerRequest(method: .post, endPoint: endpoint, params: params, headers: headers)
        APIClient.shared.dataRequest(whiteFlowerRequest: request, forType: OAuthTokenResponse.self) { result in
            switch result {
            case .success(let oauthResponse):
                completion(.success(oauthResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
