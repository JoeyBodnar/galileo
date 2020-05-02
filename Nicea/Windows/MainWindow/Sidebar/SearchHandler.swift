//
//  SearchHandler.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol SearchHandlerDelegate: AnyObject {
    
    func searchHandler(_ searchHandler: SearchHandler, didRetrieveResult result: Result<SearchResponse, Error>)
}

final class SearchHandler {
    
    var searchType: SearchType = .subreddit
    
    weak var delegate: SearchHandlerDelegate?
    
    func searchTypeDidChange(newValue: SearchType) {
        self.searchType = newValue
    }
    
    func search(text: String) {
        SearchServices.shared.search(text: text, subreddit: "iosprogramming", isSubredditOnly: searchType == .subreddit) { [weak self] result in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.searchHandler(weakSelf, didRetrieveResult: result)
        }
    }
}
