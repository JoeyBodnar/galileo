//
//  LoginViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

protocol LoginViewModelDelegate: AnyObject {
    func loginViewModel(_ viewModel: WebViewViewModel, didLoginWithUser user: User)
    func loginViewModel(_ viewModel: WebViewViewModel, didFailToLoginWithError error: Error)
}

final class WebViewViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    var authorizationRequestUrl: String? {
        if let clientID = ProcessInfo.processInfo.environment["REDDIT_CLIENT_ID"], let state = ProcessInfo.processInfo.environment["REDDIT_AUTH_URL_STATE"] {
            return "https://www.reddit.com/api/v1/authorize.compact?client_id=\(clientID)&response_type=code&state=\(state)&redirect_uri=https://www.vaporforums.io&duration=permanent&scope=privatemessages%20identity%20account%20vote%20subscribe%20mysubreddits%20edit%20submit%20read%20save%20history%20edit%20wikiread"
        }
        
        return nil
    }
    
    func handleUrl(url: URL?) {
        let queryItems = URLComponents(string: url!.absoluteString)?.queryItems
        if (queryItems?.count ?? 0) > 0 {
            if let param1 = queryItems?.filter({$0.name == "code"}).first {
                retrieveAccessToken(code: param1.value)
            }
        }
    }
    
    private func retrieveAccessToken(code: String?) {
        guard let unwrappedCode = code, let authHeader = ProcessInfo.processInfo.environment["BEARER_AUTH_HEADER"] else { return }
        AuthenticationServices.shared.retrieveToken(code: unwrappedCode, authHeader: authHeader) { [weak self] result in
            switch result {
            case .success(let tokenResponse):
                RedditClient.shared.setOAuthTokenResponse(response: tokenResponse)
                self?.getUser(accessToken: tokenResponse.accessToken)
            case .failure(let error):
                guard let weakSelf = self else { return }
                weakSelf.delegate?.loginViewModel(weakSelf, didFailToLoginWithError: error)
            }
        }
    }
    
    func getUser(accessToken: String) {
        UserServices.shared.getUser(authorizationToken: accessToken) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let user):
                weakSelf.delegate?.loginViewModel(weakSelf, didLoginWithUser: user)
            case .failure(let error):
                weakSelf.delegate?.loginViewModel(weakSelf, didFailToLoginWithError: error)
            }
        }
    }
}
