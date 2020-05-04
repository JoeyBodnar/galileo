//
//  SubredditHeaderCellContentView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/1/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol SubredditHeaderCellDelegate: AnyObject {
    
    func subredditHeaderCell(_ subredditHeaderCell: SubredditHeaderCell, didSelectMenItem menuItem: NSMenuItem)
}

final class SubredditHeaderCell: NSTableCellView {
    
    private let iconImageView: NSImageView = NSImageView()
    private let nameLabel: NSLabel = NSLabel()
    private let topView: NSView = NSView()
    private let infoLabel: NSLabel = NSLabel()
    
    private let sortButton: NSPopUpButton = NSPopUpButton()
    
    weak var delegate: SubredditHeaderCellDelegate?
    
    
    private struct Constants {
        static let imageHeightWidth: CGFloat = 60
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    func configure(subreddit: Subreddit, sort: MenuSortItem) {
        if let url = subreddit.subredditIconUrlString, url.count > 0 {
            iconImageView.setImage(with: url)
        } else {
            iconImageView.image = NSImage(named: ImageNames.subredditIconDefault)
        }
        
        nameLabel.stringValue = subreddit.data.displayName ?? subreddit.data.title
        infoLabel.stringValue = subreddit.infoText
        
        if let subrdditPrimaryHex = subreddit.data.primaryColor, let primaryNSColor = NSColor.fromHexString(hex: subrdditPrimaryHex, alpha: 1.0) {
            topView.layer?.backgroundColor = primaryNSColor.cgColor
        }
        
        sortButton.selectItem(withTitle: sort.title)
        iconImageView.alphaValue = 1.0
    }
    
    func configure(defaultFeedItem: String, sort: MenuSortItem) {
        nameLabel.stringValue = "r/\(defaultFeedItem.lowercased())"
        infoLabel.stringValue = ""
        iconImageView.image = NSImage(named: ImageNames.subredditIconDefault)
        
        sortButton.selectItem(withTitle: sort.title)
    }
    
    func configure(searchTerm: String, resultCount: Int, sort: MenuSortItem) {
        nameLabel.stringValue = "Search Results for \(searchTerm)"
        infoLabel.stringValue = "\(resultCount) results"
    }
    
    @objc func menuItemPressed(sender: NSMenuItem) {
        delegate?.subredditHeaderCell(self, didSelectMenItem: sender)
    }
}

// MARK: - Layout/Setup
extension SubredditHeaderCell {
    
    private func setupViews() {
        iconImageView.wantsLayer = true
        iconImageView.layer?.backgroundColor = NSColor.white.cgColor
        iconImageView.layer?.cornerRadius = Constants.imageHeightWidth / 2
        iconImageView.layer?.borderColor = NSColor.white.cgColor
        iconImageView.layer?.borderWidth = 3
        
        topView.wantsLayer = true
        topView.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        nameLabel.font = NSFont.boldSystemFont(ofSize: 18)
        
        let menuItemsSet1: [MenuSortItem] = [MenuSortItem(title: SortItemTitles.hot, sort: .hot), MenuSortItem(title: SortItemTitles.new, sort: .new), MenuSortItem(title: SortItemTitles.rising, sort: .rising)]
        addItems(items: menuItemsSet1)
        sortButton.menu?.addItem(NSMenuItem.separator())
        
        let menuItemsSet2: [MenuSortItem] = [MenuSortItem(title: SortItemTitles.topWeekly, sort: .topWeekly), MenuSortItem(title: SortItemTitles.topMonthly, sort: .topMonthly), MenuSortItem(title: SortItemTitles.topYearly, sort: .topYearly), MenuSortItem(title: SortItemTitles.topAllTime, sort: .topAllTime)]
        addItems(items: menuItemsSet2)
    }
    
    private func addItems(items: [MenuSortItem]) {
        for sortItem in items {
            let menuItem: NSMenuItem = NSMenuItem(title: sortItem.title, action: #selector(menuItemPressed(sender:)), keyEquivalent: "")
            menuItem.target = self
            sortButton.menu?.addItem(menuItem)
        }
    }
    
    private func layoutViews() {
        topView.setupForAutolayout(superView: self)
        iconImageView.setupForAutolayout(superView: self)
        nameLabel.setupForAutolayout(superView: self)
        infoLabel.setupForAutolayout(superView: self)
        sortButton.setupForAutolayout(superView: self)
        
        topView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        topView.topAnchor.constraint(equalTo: topAnchor).activate()
        topView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        topView.heightAnchor.constraint(equalToConstant: LayoutConstants.subredditHeaderCellTopViewHeight).activate()
        
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 50).activate()
        iconImageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15).activate()
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeightWidth).activate()
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.imageHeightWidth).activate()
        
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 0).activate()
        nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10).activate()
        
        sortButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20).activate()
        sortButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).activate()
        
        infoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).activate()
        infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).activate()
    }
}
