//
//  PostDetailHeaderCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient
import CocoaMarkdown

protocol PostDetailHeaderCellDelegate: AnyObject {
    
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectBackButton sender: NSButton)
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectSubmit commentBox: CommentTextBoxCell)
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectLink linkButton: ClearButton)
}

final class PostDetailHeaderCell: NSTableCellView {
    
    private let upvoteDownvoteView: UpvoteDownvoteView = UpvoteDownvoteView()
    private let topInfoView: PostMetaInfoView = PostMetaInfoView()
    private let contentView: PostDetailContentView = PostDetailContentView()
    private let titleLabel: LinkTitleLabel = LinkTitleLabel()
    
    private var contentViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var commentBox: CommentTextBoxCell?
    private let backButton: NSButton = NSButton()
    
    private let urlLinkButton: ClearButton = ClearButton()
    private var urlLinkButtonHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    weak var delegate: PostDetailHeaderCellDelegate?
    
    private struct Constants {
        static let backButtonTopMargin: CGFloat = 5
        static let backButtonHeightWidth: CGFloat = 35
        static let titleToBackButtonTopMargin: CGFloat = 10
        static let topInfoViewToVoteTrailingMargin: CGFloat = 8
        static let contentVeritcalPadding: CGFloat = 10
        static let commentboxTopPadding: CGFloat = 10
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commmonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commmonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.clear()
    }
    
    private func commmonInit() {
        layoutViews()
        setupViews()
    }
    
    func configure(link: Link) {
        upvoteDownvoteView.configure(voteCount: link.data.score, hideScore: link.data.hide_score, likes: link.data.likes)
        topInfoView.configure(link: link)
        
        titleLabel.stringValue = link.data.title
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        
        let linkType: LinkType = LinkType(link: link)
        switch linkType {
        case .selfText:
            contentView.configureForSelfText(link: link)
        case .imageImgur, .imageReddit, .gifImgur:
            contentView.configureForImage(link: link)
        case .hostedVideo, .gyfcatVideo, .youtubeVideo:
            contentView.configureForVideo(link: link)
        case .linkedArticle:
            let attributes = [NSAttributedString.Key.foregroundColor: NSColor.linkColor] as [NSAttributedString.Key : Any]

            let attributedTitle = NSAttributedString(string: link.data.url ?? "---", attributes: attributes)
            urlLinkButton.attributedTitle = attributedTitle
            urlLinkButtonHeightAnchor.constant = LinkCellConstants.urlLinkTextHeight
        default: break
        }
    }
    
    @objc func backButtonPressed() {
        delegate?.postDetailHeaderCell(self, didSelectBackButton: backButton)
    }
    
    @objc func didSelectLink() {
        delegate?.postDetailHeaderCell(self, didSelectLink: urlLinkButton)
    }
}

extension PostDetailHeaderCell: CommentTextBoxDelegate {
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectSubmit comment: Comment?) {
        delegate?.postDetailHeaderCell(self, didSelectSubmit: commentTextBox)
    }
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectCancel comment: Comment) { }
}

extension PostDetailHeaderCell {
    
    static func height(link: Link, width: CGFloat) -> CGFloat {
        let backButtonHeight: CGFloat = Constants.backButtonHeightWidth
        let backButtonTopMargin: CGFloat = Constants.backButtonTopMargin
        
        let topViewMetaHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let bottomInfoViewHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        
        // total height of the post content
        var contentHeight: CGFloat = 0
        
        let linkType: LinkType = LinkType(link: link)
        switch linkType {
        case .selfText:
            // comment body height calculations
            let dummyTextField: NSTextView = NSTextView()
            dummyTextField.isEditable = false
            
            let outlineViewPadding: CGFloat = 20
            let textViewWidth: CGFloat = LayoutConstants.postDetailOutlineViewWidth - LinkCellConstants.voteViewSize.width - (Constants.topInfoViewToVoteTrailingMargin * 2) - outlineViewPadding - 10
            
            let doc = CMDocument(string: link.data.selftext ?? "-", options: CMDocumentOptions.hardBreaks)
            let renderer = CMAttributedStringRenderer(document: doc, attributes: CMTextAttributes())
            contentHeight = dummyTextField.bestHeight(for: renderer!.render(), width: textViewWidth, font: CommentTableViewCellView.commentTextLabelFont)
        case .gifImgur, .imageReddit, .imageImgur:
            contentHeight = link.imgSizeForPostDetail.height
        case .gyfcatVideo, .hostedVideo, .youtubeVideo:
            contentHeight = link.videoSizeForCell.height
        default: contentHeight = 0
        }
        
        // text box
        let textBoxHeight: CGFloat = LayoutConstants.commentTextBoxContainerHeight
        
        // title height
        let dummyTitleLabel: NSTextField = NSTextField()
        dummyTitleLabel.usesSingleLineMode = false
        dummyTitleLabel.isEditable = false
        let titleHeight: CGFloat = dummyTitleLabel.bestHeight(for: link.data.title, width: width, font: LinkCellConstants.titleLabelFont)
        
        let linkHeight: CGFloat
        switch linkType {
        case .linkedArticle: linkHeight = LinkCellConstants.urlLinkTextHeight
        default: linkHeight = 0
        }
        
        return backButtonHeight + backButtonTopMargin + topViewMetaHeight + bottomInfoViewHeight + contentHeight + textBoxHeight + (Constants.contentVeritcalPadding * 2) + Constants.commentboxTopPadding + titleHeight + linkHeight
    }
}
// MARK: - Layout/Setup
extension PostDetailHeaderCell {
    
    private func setupViews() {
        backButton.bezelStyle = NSButton.BezelStyle.roundedDisclosure
        backButton.title = ""
        backButton.rotate(byDegrees: 90)
        backButton.target = self
        backButton.action = #selector(backButtonPressed)
        
        commentBox?.delegate = self
        
        urlLinkButton.alignment = .left
        urlLinkButton.target = self
        urlLinkButton.action = #selector(didSelectLink)
    }
    
    private func layoutViews() {
        if let commentBox: CommentTextBoxCell = NSView.loadFromNib(nibName: "CommentTextBoxCell", owner: nil) as? CommentTextBoxCell {
            self.commentBox = commentBox
        }
        
        upvoteDownvoteView.setupForAutolayout(superView: self)
        topInfoView.setupForAutolayout(superView: self)
        contentView.setupForAutolayout(superView: self)
        titleLabel.setupForAutolayout(superView: self)
        commentBox?.setupForAutolayout(superView: self)
        backButton.setupForAutolayout(superView: self)
        urlLinkButton.setupForAutolayout(superView: self)
        
        backButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.backButtonTopMargin).activate()
        backButton.centerXAnchor.constraint(equalTo: upvoteDownvoteView.centerXAnchor).activate()
        backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonHeightWidth).activate()
        backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonHeightWidth).activate()
        
        upvoteDownvoteView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        upvoteDownvoteView.topAnchor.constraint(equalTo: backButton.bottomAnchor).activate()
        upvoteDownvoteView.widthAnchor.constraint(equalToConstant: LinkCellConstants.voteViewSize.width).activate()
        upvoteDownvoteView.heightAnchor.constraint(equalToConstant: LinkCellConstants.voteViewSize.height).activate()
        
        topInfoView.leadingAnchor.constraint(equalTo: upvoteDownvoteView.trailingAnchor, constant: Constants.topInfoViewToVoteTrailingMargin).activate()
        topInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.topInfoViewToVoteTrailingMargin).activate()
        topInfoView.topAnchor.constraint(equalTo: upvoteDownvoteView.topAnchor).activate()
        topInfoView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
        
        titleLabel.leadingAnchor.constraint(equalTo: topInfoView.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: topInfoView.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: topInfoView.bottomAnchor).activate()
        
        urlLinkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).activate()
        urlLinkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).activate()
        urlLinkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).activate()
        urlLinkButtonHeightAnchor = urlLinkButton.heightAnchor.constraint(equalToConstant: 0)
        urlLinkButtonHeightAnchor.activate()
        
        contentView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).activate()
        contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).activate()
        contentView.topAnchor.constraint(equalTo: urlLinkButton.bottomAnchor, constant: Constants.contentVeritcalPadding).activate()
        
        // this should never be nil since i assigend above, but just check so it doesnt crash
        if let comBox = commentBox {
            contentView.bottomAnchor.constraint(equalTo: comBox.topAnchor, constant: -Constants.contentVeritcalPadding).activate()
        } else {
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentVeritcalPadding).activate()
        }
        
        commentBox?.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).activate()
        commentBox?.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).activate()
        commentBox?.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.commentboxTopPadding).activate()
        commentBox?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).activate()
        commentBox?.heightAnchor.constraint(equalToConstant: LayoutConstants.commentTextBoxContainerHeight).activate()
    }
}
