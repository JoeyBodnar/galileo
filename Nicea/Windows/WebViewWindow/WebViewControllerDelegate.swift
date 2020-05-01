//
//  LoginViewControllerDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import APIClient

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ webViewController: WebViewController, withUser user: User)
    func webViewController(_ webViewController: WebViewController, didFailToLoginWithError error: Error)
}
