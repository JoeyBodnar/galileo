//
//  LinkArticleCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class LinkArticleCell: LinkParentCell {
    
    let urlLinkButton: ClearButton = ClearButton()
    
    var urlLinkButtonHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    override func configure(link: Link) {
        super.configure(link: link)
        let linkType: LinkType = LinkType(link: link)
        switch linkType {
        case .linkedArticle:
            setUrlLinkText(link: link)
        default:
            setLinkButtonHeightTo0()
        }
    }
    
    private func setUrlLinkText(link: Link) {
        let attributes = [NSAttributedString.Key.foregroundColor: NSColor.linkColor] as [NSAttributedString.Key : Any]

        let attributedTitle = NSAttributedString(string: link.data.url ?? "---", attributes: attributes)
        urlLinkButton.attributedTitle = attributedTitle
        urlLinkButtonHeightAnchor.constant = LinkCellConstants.urlLinkTextHeight
    }
    
    private func setLinkButtonHeightTo0() {
        urlLinkButtonHeightAnchor.constant = 0
    }
    
    @objc func didSelectLink() {
        linkArticleDelegate?.linkArticleCell(self, didSelectLink: urlLinkButton)
    }
}

// MARK: - Height Calculation
extension LinkArticleCell {
    
    static func height(link: Link, width: CGFloat) -> CGFloat {
        let minHeight: CGFloat = 70
        let metaTopHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let metaBottomHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let padding: CGFloat = 2
        
        let dummyTextField: NSTextField = NSTextField()
        dummyTextField.usesSingleLineMode = false
        dummyTextField.isEditable = false
        let titleHeight: CGFloat = dummyTextField.bestHeight(for: link.data.title, width: width, font: LinkCellConstants.titleLabelFont)
        let linkType: LinkType = LinkType(link: link)
        
        var urlLinkTextTotal: CGFloat
        switch linkType {
        case .linkedArticle: urlLinkTextTotal = LinkCellConstants.urlLinkTextHeight + LinkCellConstants.urlLinkTopToTitleBottom
        default: urlLinkTextTotal = 0
        }
        
        let proposedHeight: CGFloat = titleHeight + padding + metaTopHeight + metaBottomHeight + urlLinkTextTotal
        
        return minHeight > proposedHeight ? minHeight : proposedHeight
    }
}

// MARK: - Layout/Setup
extension LinkArticleCell {
    
    private func setupViews() {
        urlLinkButton.alignment = .left
        urlLinkButton.target = self
        urlLinkButton.action = #selector(didSelectLink)
    }
    
    private func layoutViews() {
        upvoteDownvoteView.setupForAutolayout(superView: self)
        postMetaInfoView.setupForAutolayout(superView: self)
        postMetaInfoBottomView.setupForAutolayout(superView: self)
        titleLabel.setupForAutolayout(superView: self)
        urlLinkButton.setupForAutolayout(superView: self)
        
        upvoteDownvoteView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        upvoteDownvoteView.topAnchor.constraint(equalTo: topAnchor).activate()
        upvoteDownvoteView.widthAnchor.constraint(equalToConstant: LinkCellConstants.voteViewSize.width).activate()
        upvoteDownvoteView.heightAnchor.constraint(equalToConstant: LinkCellConstants.voteViewSize.height).activate()
        
        postMetaInfoView.leadingAnchor.constraint(equalTo: upvoteDownvoteView.trailingAnchor, constant: 8).activate()
        postMetaInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).activate()
        postMetaInfoView.topAnchor.constraint(equalTo: upvoteDownvoteView.topAnchor).activate()
        postMetaInfoView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
        
        titleLabel.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: postMetaInfoView.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: postMetaInfoView.bottomAnchor).activate()
        
        urlLinkButton.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        urlLinkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LinkCellConstants.urlLinkTopToTitleBottom).activate()
        urlLinkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).activate()
        urlLinkButtonHeightAnchor = urlLinkButton.heightAnchor.constraint(equalToConstant: 0)
        urlLinkButtonHeightAnchor.activate()
        
        postMetaInfoBottomView.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        postMetaInfoBottomView.trailingAnchor.constraint(equalTo: postMetaInfoView.trailingAnchor).activate()
        postMetaInfoBottomView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        postMetaInfoBottomView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
    }
}
