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
    func subredditHeaderCell(_ subredditHeaderCell: SubredditHeaderCell, didPressEnterForSearch searchField: NSSearchField)
}

final class SubredditHeaderCell: NSTableCellView {
    
    private let iconImageView: NSImageView = NSImageView()
    private let nameLabel: NSLabel = NSLabel()
    private let topView: NSView = NSView()
    private let infoLabel: NSLabel = NSLabel()
    
    private let sortButton: NSPopUpButton = NSPopUpButton()
    
    weak var delegate: SubredditHeaderCellDelegate?
    let goToSubredditField: NSSearchField = NSSearchField()
    
    private var sortButtonWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private struct Constants {
        static let imageHeightWidth: CGFloat = 60
        
        static let sortButtonWidth: CGFloat = 130
        static let sortButtonTrailingAnchor: CGFloat = 20
        
        static let goToSubredditButtonSize: NSSize = NSSize(width: 180, height: 24)
        static let iconImageViewLeadingAnchor: CGFloat = 50
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
        
        sortButton.alphaValue = 1
        sortButton.selectItem(withTitle: sort.title)
        
        iconImageView.alphaValue = 1
        sortButtonWidthConstraint.constant = Constants.sortButtonWidth
    }
    
    func configure(defaultFeedItem: String, sort: MenuSortItem) {
        nameLabel.stringValue = "r/\(defaultFeedItem.lowercased())"
        infoLabel.stringValue = ""
        iconImageView.image = NSImage(named: ImageNames.subredditIconDefault)
        iconImageView.alphaValue = 1
        
        sortButton.alphaValue = 1
        sortButton.selectItem(withTitle: sort.title)
        sortButtonWidthConstraint.constant = Constants.sortButtonWidth
    }
    
    func configure(searchResultHeaderItem: SearchResultHeaderItem) {
        nameLabel.stringValue = "Search Results for \(searchResultHeaderItem.searchTerm) in r/ \(searchResultHeaderItem.subreddit)"
        infoLabel.stringValue = "\(searchResultHeaderItem.resultCount) results"
        
        iconImageView.alphaValue = 0
        sortButton.alphaValue = 0
        sortButtonWidthConstraint.constant = 0
    }
    
    @objc func menuItemPressed(sender: NSMenuItem) {
        delegate?.subredditHeaderCell(self, didSelectMenItem: sender)
    }
}

extension SubredditHeaderCell: NSSearchFieldDelegate {
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            if goToSubredditField.stringValue.count < 2 { return true }
            delegate?.subredditHeaderCell(self, didPressEnterForSearch: goToSubredditField)
        }

        return false
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
        
        goToSubredditField.placeholderString = "Go to subreddit"
        goToSubredditField.delegate = self
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
        goToSubredditField.setupForAutolayout(superView: self)
        
        topView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        topView.topAnchor.constraint(equalTo: topAnchor).activate()
        topView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        topView.heightAnchor.constraint(equalToConstant: LayoutConstants.subredditHeaderCellTopViewHeight).activate()
        
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: Constants.iconImageViewLeadingAnchor).activate()
        iconImageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15).activate()
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeightWidth).activate()
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.imageHeightWidth).activate()
        
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 0).activate()
        nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10).activate()
        
        sortButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: Constants.sortButtonTrailingAnchor).activate()
        sortButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).activate()
        sortButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.sortButtonWidth).activate()
        sortButtonWidthConstraint = sortButton.widthAnchor.constraint(equalToConstant: Constants.sortButtonWidth)
        sortButtonWidthConstraint.activate()
        
        infoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).activate()
        infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).activate()
        
        goToSubredditField.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: 5).activate()
        goToSubredditField.centerYAnchor.constraint(equalTo: sortButton.centerYAnchor).activate()
        goToSubredditField.widthAnchor.constraint(equalToConstant: Constants.goToSubredditButtonSize.width).activate()
        goToSubredditField.heightAnchor.constraint(equalToConstant: Constants.goToSubredditButtonSize.height).activate()
    }
}
