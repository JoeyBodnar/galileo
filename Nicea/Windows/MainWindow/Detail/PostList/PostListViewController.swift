//
//  PostListView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/3/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol PostListViewControllerDelegate: AnyObject {
    
    func postListViewController(_ postListViewController: PostListViewController, didSelectViewComments link: Link)
    func postListViewController(_ postListViewController: PostListViewController, subredditDidChange subreddit: String)
}

/// Main post list in the content view
final class PostListViewController: NSViewController {
    
    let scrollView: NSScrollView = NSScrollView()
    let tableView: PostListTableView = PostListTableView()
    private let indicator: NSActivityIndicator = NSActivityIndicator()
    
    let viewModel: PostListViewModel = PostListViewModel()
    
    private lazy var tableViewDelegate: PostListDelegate = {
        return PostListDelegate(dataSource: viewModel.dataSource, cellDelegate: self, headerDelegate: self, linkArticleDelegate: self, viewModel: viewModel)
    }()
    
    weak var delegate: PostListViewControllerDelegate?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        layoutViews()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLoading(_ isLoading: Bool, isNewSubreddit: Bool = false) {
        isLoading ? setLoading(isNewSubreddit: isNewSubreddit) : setNotLoading()
    }
    
    // MARK: Private
    private func didSetResults(isNewSubreddit: Bool, subreddit: String, posts: [Any]) {
        view.window?.title = subreddit
        viewModel.dataSource.posts = isNewSubreddit ? posts : viewModel.dataSource.posts + posts
        setLoading(false)
        if isNewSubreddit { // scroll to top for new subreddit
            tableView.scroll(NSPoint.zero)
        }
        tableView.reloadData()
    }
    
    private func setNotLoading() {
        indicator.alphaValue = 0
        indicator.stopAnimation(nil)
        tableView.alphaValue = 1
    }
    
    private func setLoading(isNewSubreddit: Bool = false) {
        indicator.alphaValue = 1
        indicator.startAnimation(nil)
        tableView.alphaValue = isNewSubreddit ? 0 : 1
    }
}

/// MARK: - Scrollview Notifications
extension PostListViewController {

    @objc func scrollViewBoundsDidChange(notification: NSNotification) {
        if let object = notification.object as? NSClipView {
            let endY: CGFloat = object.bounds.origin.y + object.bounds.height
            let totalContentSize: CGFloat = tableView.intrinsicContentSize.height
            
            if endY > (totalContentSize - 100) {
                setLoading(true)
                viewModel.getNextPosts()
            }
           
            let invisibleRows: [NSTableRowView] = viewModel.dataSource.invisibleRows(inScrollView: scrollView, endY: endY)
            viewModel.pauseOffScreenVideos(rows: invisibleRows)
        }
    }
}

// MARK: - SubredditHeaderCellDelegate
extension PostListViewController: SubredditHeaderCellDelegate {
    
    func subredditHeaderCell(_ subredditHeaderCell: SubredditHeaderCell, didSelectMenItem menuItem: NSMenuItem) {
        setLoading(isNewSubreddit: true)
        viewModel.didSelectSortMenuItem(menuItem: menuItem)
    }
}

// MARK: - LinkArticleCellDelegate
extension PostListViewController: LinkArticleCellDelegate {
    
    func linkArticleCell(_ linkArticleCell: LinkArticleCell, didSelectLink button: ClearButton) {
        guard let link = viewModel.dataSource.posts[tableView.row(for: linkArticleCell)] as? Link else { return }
        guard let urlString: String = link.data.url else { return }
        
        let webViewWindowController: WebViewWindowController = WebViewWindowController(contentType: .article(url: urlString))
        webViewWindowController.window?.setFrame(LayoutConstants.defaultWebViewWindowRect, display: true)
        webViewWindowController.window?.setFrameOriginToPositionWindowInCenterOfScreen()
        DispatchQueue.main.async {
            webViewWindowController.showWindow(self)
        }
    }
}

// MARK: - LinkParentCellDelegate
extension PostListViewController: LinkParentCellDelegate {
    
    func linkParentCell(_ linkParentCell: LinkParentCell, didSelectShare button: ClearButton) {
        let row: Int = tableView.row(for: linkParentCell)
        let text = (viewModel.dataSource.posts[row] as? Link)?.data.url ?? ""
        viewModel.didSelectShare(button: button, shareUrl: text)
    }
    
    func linkParentCell(_ linkParentCell: LinkParentCell, didPressSave button: ClearButton) {
        let row: Int = tableView.row(for: linkParentCell)
        let isSaved: Bool = button.title == Strings.saveButtonUnsaveText
        if let post = viewModel.dataSource.posts[row] as? Link {
            viewModel.savePost(post: post, isSaved: isSaved, button: button)
        }
    }
    
    func linkParentCell(_ linkParentCell: LinkParentCell, didSelectImage image: NSImage) {
        guard let link: Link = viewModel.dataSource.posts[tableView.row(for: linkParentCell)] as? Link else { return }
        guard let highResUrl = link.highResolutionImageUrl else { return }
        let newWindow: PhotoViewerWindowController = PhotoViewerWindowController(imageUrls: [highResUrl])
        newWindow.window?.setFrame(LayoutConstants.defaultPhotoViewerWindowRect, display: true)
        newWindow.showWindow(self)
    }

    func linkParentCell(_ linkParentCell: LinkParentCell, didPressVote upvoteDownvoteView: UpvoteDownvoteView, direction: VoteDirection) {
        let row: Int = tableView.row(for: linkParentCell)
        guard let link = viewModel.dataSource.posts[row] as? Link else { return }
        viewModel.vote(post: link, direction: direction, upvoteDownvoteView: upvoteDownvoteView)
    }
    
    func linkParentCell(_ linkParentCell: LinkParentCell, postMetaBottomView: PostMetaInfoBottomView, didSelectViewComments button: ClearButton) {
        guard let link: Link = viewModel.dataSource.posts[tableView.row(for: linkParentCell)] as? Link else { return }
        delegate?.postListViewController(self, didSelectViewComments: link)
    }
}

// MARK: - PostListViewModelDelegate
extension PostListViewController: PostListViewModelDelegate {
    
    func postListViewModel(_ viewModel: PostListViewModel, subredditDidChange subreddit: String) {
        delegate?.postListViewController(self, subredditDidChange: subreddit)
    }
    
    func postListViewModel(_ viewModel: PostListViewModel, didCompleteSaveOperation result: Result<String, Error>, wasSave: Bool, post: Link, button: ClearButton) {
        switch result {
        case .success(let text): button.title = text
        case .failure(let error): print(error)
        }
    }
    
    func postListViewModel(_ viewModel: PostListViewModel, didVoteWithDirection direction: VoteDirection, post: Link, result: Result<Link, Error>) {
        switch result {
        case .success(let link):
            link.data.likes = direction == .up ? true : false
        default: break
        }
    }
    
    func postListViewModel(_ viewModel: PostListViewModel, didCompleteSaveOperation itemid: String, wasSave: Bool, button: ClearButton) {
        button.title = Strings.saveButtonUnsaveText
    }
    
    func postListViewModel(_ viewModel: PostListViewModel, saveOperationDidFail error: Error, button: ClearButton) {
        button.title = Strings.saveFailedTosave
    }
    
    func postListViewModel(_ postListViewModelDelegate: PostListViewModel, didRetrievePosts posts: [Any], isNewSubreddit newSubreddit: Bool) {
        didSetResults(isNewSubreddit: newSubreddit, subreddit: viewModel.subreddit, posts: posts)
        viewModel.isFetching = false
        view.window?.title = viewModel.subreddit
    }
}

// MARK: - Layout/Setup
extension PostListViewController {
    
    private func setupViews() {
        view.wantsLayer = true
        NotificationCenter.default.addObserver(self, selector: #selector(scrollViewBoundsDidChange(notification:)), name: NSScrollView.boundsDidChangeNotification, object: scrollView.contentView)
        
        tableView.dataSource = viewModel.dataSource
        tableView.delegate = tableViewDelegate
        
        scrollView.documentView = tableView
    }
    
    private func layoutViews() {
        scrollView.setupForAutolayout(superView: view)
        tableView.setupForAutolayout(superView: scrollView)
        indicator.setupForAutolayout(superView: view)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        
        indicator.center(in: view)
    }
}
