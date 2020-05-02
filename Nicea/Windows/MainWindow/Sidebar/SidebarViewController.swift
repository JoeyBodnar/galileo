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
    func didSelectItem(item: SidebarItem)
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
        viewModel.getTrendingSubreddits()
        viewModel.getSubscribedSubreddits()
        viewModel.getCurrentUser()
    }
}

extension SidebarViewController: SidebarViewModelDelegate {
    
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
    
    func headerView(_ headerView: HeaderView, didFailToLoginWithError error: Error) {
        
    }
    
    func headerView(_ headerView: HeaderView, didLoginWithUser user: User) {
        viewModel.getSubscribedSubreddits()
    }
}

extension SidebarViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return item is SidebarSection ? 35 : 28
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let sidebarItem = item as? SidebarItem {
            delegate?.didSelectItem(item: sidebarItem)
        }
        
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is SidebarSection
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return viewModel.dataSource.outlineView(outlineView, viewFor: tableColumn, item: item)
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

extension SidebarViewController: LoggedInHeaderContentViewDelegate {
    
    func loggedInHeaderContentView(_ loggedInHeaderContentView: LoggedInHeaderContentView, didSelectMailButton button: ImageButton, withEmptyMailbox mailBoxIsEmpty: Bool) {
        
    }
}

extension SidebarViewController {
    
    private func setupviews() {
        headerView.delegate = self
        
        contentView.outlineView.delegate = self
        contentView.outlineView.dataSource = self
        
        headerView.loggedInView.delegate = self
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
