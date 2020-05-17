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
    
    func searchHandler(_ searchHandler: SearchHandler, didRetrieveResult result: Result<[Link], Error>)
}

final class SearchHandler {
    
    var searchType: SearchType = .allReddit
    var searchTerm: String = ""
    var subreddit: String = ""
    
    weak var delegate: SearchHandlerDelegate?
    
    func searchTypeDidChange(newValue: SearchType) {
        self.searchType = newValue
    }
    
    func search() {
        SearchServices.shared.search(text: searchTerm, subreddit: subreddit, isSubredditOnly: searchType == .subreddit) { [weak self] result in
            self?.handleSearchResponse(result: result)
        }
    }
    
    private func handleSearchResponse(result: Result<SearchResponse, Error>) {
    
        switch result {
        case .success(let searchResponse):
            delegate?.searchHandler(self, didRetrieveResult: .success(searchResponse.data.children ?? []))
        case .failure(let error):
            delegate?.searchHandler(self, didRetrieveResult: .failure(error))
        }
        /*let links: [Link] = searchResponse.data.children ?? []
        let subredditSearched: String = subreddit == "" ? "All" : subreddit
        let headerItem: SearchResultHeaderItem = SearchResultHeaderItem(searchTerm:
            searchTerm ?? "", resultCount: links.count, subreddit: subredditSearched)
        listType = .searchResults
        let items: [Any] = [PostListHeaderCellType.searchResults(headerItem: headerItem)] + links
        delegate?.postListViewModel(self, didRetrievePosts: items, isNewSubreddit: true)*/
    }
}
