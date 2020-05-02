//
//  SideBarViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/21/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol SidebarViewModelDelegate: AnyObject {
    
    func didFetchSubredditSbscriptions()
    func sidebarViewModel(_ viewModel: SidebarViewModel, didRetrieveCurrentUser user: User)
    func sidebarViewModel(_ viewModel: SidebarViewModel, didFailToRetrieveCurrentUser error: Error)
}

final class SidebarViewModel {
    
    weak var delegate: SidebarViewModelDelegate?
    let dataSource: SidebarDataSource = SidebarDataSource()
    
    init() { }
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var redditFeeds: [SidebarItem] {
        if SessionManager.shared.isLoggedIn {
            return [SidebarItem.defaultRedditFeed(name: "Home", image: ImageNames.home), SidebarItem.defaultRedditFeed(name: "Popular", image: ImageNames.trending), SidebarItem.defaultRedditFeed(name: "All", image: ImageNames.home)]
        } else {
            return [SidebarItem.defaultRedditFeed(name: "Popular", image: ImageNames.trending), SidebarItem.defaultRedditFeed(name: "All", image: ImageNames.home)]
        }
    }
    
    func getSubscribedSubreddits() {
        guard let authToken = DefaultsManager.shared.userAuthorizationToken else { return }
        UserServices.shared.getSubscribedSubreddits(authorizationToken: authToken) { result in
            switch result {
            case .success(let mySubredditResponse):
                self.setDataSource(subredditListResponse: mySubredditResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setDataSource(subredditListResponse: MySubredditListResponse) {
        let subreddits: [Subreddit] = subredditListResponse.data.children ?? []
        
        let sideBarItems: [SidebarItem] = subreddits.map { subreddit -> SidebarItem in
            return SidebarItem.subscriptionSubreddit(subreddit: subreddit)
        }
        
        let section: SidebarSection = SidebarSection(sectionType: .mySubscriptions, children: sideBarItems)
        dataSource.sections.append(section)
        delegate?.didFetchSubredditSbscriptions()
    }
    
    func getTrendingSubreddits() {
        PostServices.shared.trendingSubreddits { [weak self] result in
            switch result {
            case .success(let trendingResponse):
                let trendingItems: [String] = trendingResponse.subreddits
                let trendingSidebarItems: [SidebarItem] = trendingItems.map { SidebarItem.trendingSubreddit(name: $0, image: ImageNames.trending)}
                let trendingSection: SidebarSection = SidebarSection(sectionType: .trending, children: trendingSidebarItems)
                
                let redditSection: SidebarSection = SidebarSection(sectionType: .default, children: self?.redditFeeds ?? [])
                
                let searchSection: SidebarSection = SidebarSection(sectionType: .search, children: [SidebarItem.search, SidebarItem.searchOptions])
                
                self?.dataSource.sections.insert(searchSection, at: 0)
                self?.dataSource.sections.insert(redditSection, at: 1)
                self?.dataSource.sections.insert(trendingSection, at: 2)
                self?.delegate?.didFetchSubredditSbscriptions()
            case .failure(let error): print(error)
            }
        }
    }
    
    func getCurrentUser() {
        guard let authToken = DefaultsManager.shared.userAuthorizationToken else { return }
        UserServices.shared.getUser(authorizationToken: authToken) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let user):
                weakSelf.delegate?.sidebarViewModel(weakSelf, didRetrieveCurrentUser: user)
            case .failure(let error):
                weakSelf.delegate?.sidebarViewModel(weakSelf, didFailToRetrieveCurrentUser: error)
            }
        }
    }
    
    func shouldSelectItem(_ outlineView: NSOutlineView, item: Any) -> Bool {
        if let sidebarItem = item as? SidebarItem {
            switch sidebarItem {
            case .search:
                let row = outlineView.row(forItem: item)
                let view = outlineView.view(atColumn: 0, row: row, makeIfNecessary: false) as! SidebarSearchCell
                view.searchField.becomeFirstResponder()
            default: break
            }
        }
        return true
    }
}
