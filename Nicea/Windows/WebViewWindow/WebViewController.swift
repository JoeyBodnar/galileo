//
//  WebViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import WebKit
import APIClient

enum WebViewControllerContentType {
    
    case login
    case article(url: String)
}

final class WebViewController: NSViewController {
    private let webView: WKWebView = WKWebView()
    
    private var urlObservation: NSKeyValueObservation?
    private let viewModel: WebViewViewModel = WebViewViewModel()
    
    weak var delegate: WebViewControllerDelegate?
    
    var contentType: WebViewControllerContentType = .login
    
    convenience init(contentType: WebViewControllerContentType) {
        self.init(nibName: nil, bundle: nil)
        self.contentType = contentType
    }
    
    override func loadView() {
        view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        webView.setupForAutolayout(superView: view)
        webView.pinToSides(superView: view)
        
        var urlString: String = ""
        
        switch contentType {
        case .login:
            urlString = viewModel.authorizationRequestUrl ?? ""
            urlObservation = webView.observe(\.url) { [weak self] webView, _ in
                self?.viewModel.handleUrl(url: webView.url)
            }
        case .article(let url):
            urlString = url
        }
        
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: LoginViewModelDelegate {
    func loginViewModel(_ viewModel: WebViewViewModel, didLoginWithUser user: User) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.webViewController(weakSelf, withUser: user)
            weakSelf.view.window?.close()
        }
    }
    
    func loginViewModel(_ viewModel: WebViewViewModel, didFailToLoginWithError error: Error) {
        delegate?.webViewController(self, didFailToLoginWithError: error)
    }
}
