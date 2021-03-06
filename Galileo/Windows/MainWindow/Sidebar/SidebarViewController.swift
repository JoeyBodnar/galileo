//
//  SidebarViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/21/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol SidebarViewControllerDelegate: AnyObject {
    
    func sidebarViewController(_ sidebarViewController: SidebarViewController, didSelectItem item: SidebarItem)
    func sidebarViewController(_ sidebarViewController: SidebarViewController, searchPressed searchField: NSSearchField)
    func sidebarViewController(_ sidebarViewController: SidebarViewController, searchTypeDidChange searchType: SearchType)
}

final class SidebarViewController: NSViewController {
    
    weak var delegate: SidebarViewControllerDelegate?

    private let contentView: SidebarContentView = SidebarContentView()
    private let headerView: HeaderView = HeaderView()
    let viewModel: SidebarViewModel = SidebarViewModel()
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupviews()
        viewModel.delegate = self
        setup()
    }
    
    private func setup() {
        viewModel.getTrendingSubreddits()
        viewModel.getSubscribedSubreddits()
        viewModel.getCurrentUser()
    }
}

extension SidebarViewController: SidebarViewModelDelegate {
    
    func sidebarViewModel(_ viewModel: SidebarViewModel, didChangeSearchSubreddit item: Any) {
        self.contentView.outlineView.reloadItem(viewModel.dataSource.sections[0], reloadChildren: true)
    }
    
    func sidebarViewModel(_ viewModel: SidebarViewModel, didFailToRetrieveCurrentUser error: Error) {
        headerView.loggedIn = false
    }
    
    func sidebarViewModel(_ viewModel: SidebarViewModel, didRetrieveCurrentUser user: User) {
        headerView.loggedInView.setup(user: user)
    }
    
    func didFetchSubredditSbscriptions() {
        contentView.outlineView.reloadData()
        contentView.outlineView.expandItem(nil, expandChildren: true)
    }
}

extension SidebarViewController: HeaderViewDelegate {
    
    func headerView(_ headerView: HeaderView, didFailToLoginWithError error: Error) { }
    
    func headerViewDidSelectLogout(_ headerView: HeaderView) {
        RedditClient.shared.apiClient.authToken = nil
        RedditClient.shared.apiClient.refreshToken = nil
        DefaultsManager.shared.userAuthorizationToken = nil
        viewModel.dataSource.sections = []
        contentView.outlineView.reloadData()
        setup()
    }
    
    func headerView(_ headerView: HeaderView, didLoginWithUser user: User) {
        viewModel.getSubscribedSubreddits()
    }
}

extension SidebarViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return viewModel.heightOfRow(outlineView, heightOfRowByItem: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let sidebarItem = item as? SidebarItem {
            delegate?.sidebarViewController(self, didSelectItem: sidebarItem)
        }
        
        viewModel.getCurrentUser()
        return viewModel.shouldSelectItem(outlineView, item: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is SidebarSection
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view: NSView? = viewModel.dataSource.outlineView(outlineView, viewFor: tableColumn, item: item)
        (view as? SidebarSearchCell)?.delegate = self
        (view as? SidebarSearchToggleCell)?.delegate = self
        return view
    }
}

extension SidebarViewController: SidebarSearchCellDelegate {
    
    func sidebarSearchCell(_ sidebarSearchCell: SidebarSearchCell, didStartSearching searchField: NSSearchField) {
        delegate?.sidebarViewController(self, searchPressed: searchField)
    }
}

extension SidebarViewController: SidebarSearchToggleCellDelegate {
    
    func sidebarSearchToggleCell(_ sidebarSearchToggleCell: SidebarSearchToggleCell, searchTypeDidChange searchType: SearchType) {
        delegate?.sidebarViewController(self, searchTypeDidChange: searchType)
    }
}

extension SidebarViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return viewModel.dataSource.outlineView(outlineView, isItemExpandable: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return viewModel.dataSource.outlineView(outlineView, child: index, ofItem: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return viewModel.dataSource.outlineView(outlineView, numberOfChildrenOfItem: item)
    }
}

extension SidebarViewController {
    
    private func setupviews() {
        headerView.delegate = self
        contentView.outlineView.delegate = self
        contentView.outlineView.dataSource = self
    }
    
    private func layout() {
        headerView.setupForAutolayout(superView: view)
        contentView.setupForAutolayout(superView: view)
        
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        headerView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        headerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).activate()
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
    }
}
