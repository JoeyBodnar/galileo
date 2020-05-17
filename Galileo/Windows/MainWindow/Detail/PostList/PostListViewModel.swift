//
//  PostListViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol PostListViewModelDelegate: AnyObject {
    
    func postListViewModel(_ postListViewModelDelegate: PostListViewModel, didRetrievePosts posts: [Any], isNewSubreddit newSubreddit: Bool)
    
    /// called when successfully voted on a post
    func postListViewModel(_ viewModel: PostListViewModel, didVoteWithDirection direction: VoteDirection, post: Link, result: Result<Link, Error>)
    
    /// the string is the text to assign to the button
    func postListViewModel(_ viewModel: PostListViewModel, didCompleteSaveOperation result: Result<String, Error>, wasSave: Bool, post: Link, button: ClearButton)
    
    func postListViewModel(_ viewModel: PostListViewModel, subredditDidChange subreddit: String)
}

final class PostListViewModel {
    
    init() {
        searchHandler.delegate = self
    }
    
    weak var delegate: PostListViewModelDelegate?
    
    var paginator: Paginator = Paginator()
    var subreddit: String = "" {
        didSet {
            delegate?.postListViewModel(self, subredditDidChange: subreddit)
        }
    }
    
    var isFetching: Bool = false // set to true in PostListViewModel, set to false when tableview updates in DetailviewController
    
    var listType: PostListType = PostListType.subreddit
    
    /// set in didSelectSubreddit method
    var currentSort: MenuSortItem = MenuSortItem(title: SortItemTitles.hot, sort: .hot)
    
    let dataSource: PostListDataSource = PostListDataSource(posts: [])
    
    // MARK: - Search
    var searchTerm: String?
    var searchType: SearchType = .allReddit
    let searchHandler: SearchHandler = SearchHandler()
    
    func vote(post: Link, direction: VoteDirection, upvoteDownvoteView: UpvoteDownvoteView) {
        guard SessionManager.shared.isLoggedIn else { return }
        
        PostServices.shared.votePost(id: post.data.name, direction: direction) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success:
                weakSelf.delegate?.postListViewModel(weakSelf, didVoteWithDirection: direction, post: post, result: Result.success(post))
            case .failure(let error):
                weakSelf.delegate?.postListViewModel(weakSelf, didVoteWithDirection: direction, post: post, result: Result.failure(error))
            }
        }
    }
    
    func didSelectSortMenuItem(menuItem: NSMenuItem) {
        switch menuItem.title {
        case SortItemTitles.new: currentSort = MenuSortItem(title: menuItem.title, sort: .new)
        case SortItemTitles.hot: currentSort = MenuSortItem(title: menuItem.title, sort: .hot)
        case SortItemTitles.rising: currentSort = MenuSortItem(title: menuItem.title, sort: .rising)
        case SortItemTitles.topWeekly: currentSort = MenuSortItem(title: menuItem.title, sort: .topWeekly)
        case SortItemTitles.topMonthly: currentSort = MenuSortItem(title: menuItem.title, sort: .topMonthly)
        case SortItemTitles.topYearly: currentSort = MenuSortItem(title: menuItem.title, sort: .topYearly)
        case SortItemTitles.topAllTime: currentSort = MenuSortItem(title: menuItem.title, sort: .topAllTime)
        default: break
        }
        
        paginator = Paginator() // reset as if it were a new subreddit, because we will have to reset paginator as well
        switch listType {
        case .home: fetchHomeFeed(isNewSubreddit: true, sort: currentSort.sort)
        default: fetchPosts(isNewSubreddit: true)
        }
    }
    
    /// need to pass the button because need to change the title based on saved state
    func savePost(post: Link, isSaved: Bool, button: ClearButton) {
        guard SessionManager.shared.isLoggedIn else { return }
        
        if isSaved { // then unsave
            PostServices.shared.unsavePost(id: post.data.name) { [weak self] result in
                self?.handleDidSave(result: result, post: post, wasSave: false, button: button)
            }
        } else { // then save
            PostServices.shared.savePost(id: post.data.name) { [weak self] result in
                self?.handleDidSave(result: result, post: post, wasSave: true, button: button)
            }
        }
    }
    
    func getNextPosts() {
        switch listType {
        case .home: fetchHomeFeed(isNewSubreddit: false, sort: currentSort.sort)
        case .searchResults: break
        default: fetchPosts(isNewSubreddit: false)
        }
    }
    
    /// the method called from SplitViewController when you first select a sidebar item
    func didSelectSubreddit(subreddit: String, isHomeFeed: Bool) {
        listType = isHomeFeed ? PostListType.home : PostListType.subreddit
        
        paginator = Paginator() // reset paginator for new subreddit
        currentSort = MenuSortItem(title: SortItemTitles.hot, sort: .hot)
        
        switch listType {
        case .home: fetchHomeFeed(isNewSubreddit: true, sort: currentSort.sort)
        default:
            self.subreddit = subreddit
            fetchPosts(isNewSubreddit: true)
        }
    }
    
    func pauseOffScreenVideos(rows: [NSTableRowView]) {
        for row in rows {
            if let videoLinkCell = row.view(atColumn: 0) as? LinkVideoCell {
                if videoLinkCell.videoView.isPlaying {
                    videoLinkCell.videoView.pauseForScroll()
                }
            }
        }
    }
    
    func didSelectShare(button: ClearButton, shareUrl: String) {
        button.title = "copied!"
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(shareUrl, forType: NSPasteboard.PasteboardType.string)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            button.title = Strings.shareButtonText
        }
    }
    
    func handleSearchPressed(text: String) {
        searchTerm = text
        searchHandler.searchType = self.searchType
        
        switch searchType {
        case .allReddit: searchHandler.subreddit = "all"
        case .subreddit: searchHandler.subreddit = subreddit
        }
        
        searchHandler.searchTerm = text
        searchHandler.search()
    }
    
    // MAARK: - Private
    
    /// called for both saved and unsaved operations for posts
    private func handleDidSave(result: Result<Bool, Error>, post: Link, wasSave: Bool, button: ClearButton) {
        switch result {
        case .success:
            let buttonText: String = wasSave ? Strings.saveButtonUnsaveText : Strings.saveButtonDefaultText
            post.data.saved = wasSave ? true : false
            
            delegate?.postListViewModel(self, didCompleteSaveOperation: Result.success(buttonText), wasSave: wasSave, post: post, button: button)
        case .failure(let error):
            delegate?.postListViewModel(self, didCompleteSaveOperation: Result.failure(error), wasSave: wasSave, post: post, button: button)
        }
    }
    
    /// fetch posts for a specific subreddit, including /r/all and /r/popular
    private func fetchPosts(isNewSubreddit: Bool) {
        if isFetching { return }
        isFetching = true
        if isNewSubreddit {
            fetchNewSubreddit()
        } else { // paginate and get more posts
            PostServices.shared.getPostsForSubreddit(subreddit: subreddit, isLoggedIn: SessionManager.shared.isLoggedIn, paginator: paginator, sort: currentSort.sort) { [weak self] result in
                self?.handleSubredditPaginationResponse(result: result, isNewSubreddit: false)
            }
        }
        
    }
    
    /// fetch a new subreddit and the info about that specific subreddit.
    private func fetchNewSubreddit() {
        let group: DispatchGroup = DispatchGroup()
        
        var allItems: [Any] = []
        var posts: [Link] = []
        var newSubreddit: Subreddit!
        
        group.enter()
        PostServices.shared.getPostsForSubreddit(subreddit: subreddit, isLoggedIn: SessionManager.shared.isLoggedIn, paginator: paginator, sort: currentSort.sort) { [weak self] result in
            switch result {
            case .success(let subredditResponse):
                self?.paginator = subredditResponse.paginator
                posts = subredditResponse.data.children ?? []
            case .failure(let error): print(error)
            }
            group.leave()
        }
        
        group.enter()
        PostServices.shared.getAboutSubrddit(subreddit: subreddit) { result in
            switch result {
            case .success(let retrivedSubreddit):
                newSubreddit = retrivedSubreddit
            case .failure(let error): print(error)
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let weakSelf = self else { return }
            if let unwrappedRetrievedSubreddit = newSubreddit {
                allItems = [PostListHeaderCellType.subreddit(subreddit: unwrappedRetrievedSubreddit)] + posts
            } else {
                allItems = [PostListHeaderCellType.defaultRedditFeed(name: weakSelf.subreddit)] + posts // in this case it will be "All" or "Popular" for the subreddit
            }
            
            weakSelf.delegate?.postListViewModel(weakSelf, didRetrievePosts: allItems, isNewSubreddit: true)
        }
    }
    
    /// fetch the user's personalized front page feed. 
    private func fetchHomeFeed(isNewSubreddit: Bool, sort: Sort) {
        if isFetching { return }
        isFetching = true
        guard SessionManager.shared.isLoggedIn else { return }
        PostServices.shared.getHomeFeed(paginator: paginator, sort: sort) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let subredditResponse):
                weakSelf.paginator = subredditResponse.paginator
                var posts: [Any] = subredditResponse.data.children ?? []
                if isNewSubreddit { posts = [PostListHeaderCellType.defaultRedditFeed(name: "home")] + posts }
                weakSelf.delegate?.postListViewModel(weakSelf, didRetrievePosts: posts, isNewSubreddit: isNewSubreddit)
            case .failure(let error): print(error)
            }
        }
    }
    
    /// Used for handling response to a pagination request for a subreddit
    private func handleSubredditPaginationResponse(result: Result<SubredditResponse, Error>, isNewSubreddit: Bool) {
        switch result {
        case .success(let subredditResponse):
            self.paginator = subredditResponse.paginator
            self.delegate?.postListViewModel(self, didRetrievePosts: subredditResponse.data.children ?? [], isNewSubreddit: isNewSubreddit)
        case .failure(let error): print(error)
        }
    }
}

extension PostListViewModel: SearchHandlerDelegate {
    
    func searchHandler(_ searchHandler: SearchHandler, didRetrieveResult result: Result<[Link], Error>) {
        switch result {
        case .success(let links):
            listType = .searchResults
            let headerItem: SearchResultHeaderItem = SearchResultHeaderItem(searchTerm: searchHandler.searchTerm, resultCount: links.count, subreddit: searchHandler.subreddit)
            let items: [Any] = [PostListHeaderCellType.searchResults(headerItem: headerItem)] + links
            delegate?.postListViewModel(self, didRetrievePosts: items, isNewSubreddit: true)
        case .failure: break
        }
    }
}
