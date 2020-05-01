//
//  SideBarViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/21/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
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
    
    var redditFeeds: [SidebarDefaultItem] {
        if SessionManager.shared.isLoggedIn {
            return [SidebarDefaultItem(title: "Home", imageName: "home"), SidebarDefaultItem(title: "Popular", imageName: "trending"), SidebarDefaultItem(title: "All", imageName: "home")]
        } else {
            return [SidebarDefaultItem(title: "Popular", imageName: "home"), SidebarDefaultItem(title: "All", imageName: "home")]
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
        let section: SidebarSection = SidebarSection(sectionType: .mySubscriptions, children: subredditListResponse.data.children!)
        dataSource.sections.append(section)
        delegate?.didFetchSubredditSbscriptions()
    }
    
    func getTrendingSubreddits() {
        PostServices.shared.trendingSubreddits { [weak self] result in
            switch result {
            case .success(let trendingResponse):
                let section: SidebarSection = SidebarSection(sectionType: .trending, children: trendingResponse.subreddits)
                
                let redditSection: SidebarSection = SidebarSection(sectionType: .default, children: self?.redditFeeds ?? [])
                self?.dataSource.sections.insert(redditSection, at: 0)
                self?.dataSource.sections.insert(section, at: 1)
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
    
}
