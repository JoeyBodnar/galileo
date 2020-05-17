//
//  LinkVideoCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/9/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class LinkVideoCell: LinkParentCell {
    
    let videoView: VideoView = VideoView()
    private var imageViewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var imageViewWidthAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
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
        videoView.clear()
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    override func configure(link: Link) {
        super.configure(link: link)
        let size: NSSize = link.videoSizeForCell
        let linkType: LinkType = LinkType(link: link)
        
        let rect: NSRect = NSRect(origin: .zero, size: size)
        switch linkType {
        case .hostedVideo:
            if let redditLink = link.data.media?.redditVideo?.url, let url = URL(string: redditLink) {
                let videoViewItem: VideoViewItem = VideoViewItem(isYoutube: false, url: url, duration: TimeInterval(link.data.media?.redditVideo?.duration ?? 0), rect: rect)
                videoView.setup(item: videoViewItem)
            }
        case .youtubeVideo:
            if let url = link.youtubeUrl {
                let videoViewItem: VideoViewItem = VideoViewItem(isYoutube: true, url: url, duration: 0, rect: NSRect(origin: .zero, size: size))
                videoView.setup(item: videoViewItem)
            }
        case .gyfcatVideo:
            guard let redditVideo = link.data.preview?.redditMediaPreview else { return }
            if let redditLink = redditVideo.url, let url = URL(string: redditLink) {
                let videoViewItem: VideoViewItem = VideoViewItem(isYoutube: false, url: url, duration: TimeInterval(redditVideo.duration ?? 0), rect: rect)
                videoView.setup(item: videoViewItem)
            }
        default: break
        }
    
        imageViewWidthAnchor.constant = size.width
        imageViewHeightAnchor.constant = size.height
    }
}

extension LinkVideoCell {
    
    static func height(link: Link, width: CGFloat) -> CGFloat {
        let minHeight: CGFloat = 70
        let metaTopHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let metaBottomHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let padding: CGFloat = 2 + LinkCellConstants.mediaContentSpacingToTitle
        
        let dummyTextField: NSTextField = NSTextField()
        dummyTextField.usesSingleLineMode = false
        dummyTextField.isEditable = false
        let titleHeight: CGFloat = dummyTextField.bestHeight(for: link.data.title, width: width, font: LinkCellConstants.titleLabelFont)
        
        let imgHeight: CGFloat = link.videoSizeForCell.height
        let proposedHeight: CGFloat = titleHeight + padding + metaTopHeight + metaBottomHeight + imgHeight
    
        return minHeight > proposedHeight ? minHeight : proposedHeight
    }
}

extension LinkVideoCell {
    
    private func setupViews() { }
    
    private func layoutViews() {
        upvoteDownvoteView.setupForAutolayout(superView: self)
        postMetaInfoView.setupForAutolayout(superView: self)
        postMetaInfoBottomView.setupForAutolayout(superView: self)
        titleLabel.setupForAutolayout(superView: self)
        videoView.setupForAutolayout(superView: self)
        
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
        
        videoView.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        videoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LinkCellConstants.mediaContentSpacingToTitle).activate()
        imageViewHeightAnchor = videoView.heightAnchor.constraint(equalToConstant: 300)
        imageViewHeightAnchor.activate()
        
        imageViewWidthAnchor = videoView.widthAnchor.constraint(equalToConstant: 300)
        imageViewWidthAnchor.activate()
        
        postMetaInfoBottomView.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        postMetaInfoBottomView.trailingAnchor.constraint(equalTo: postMetaInfoView.trailingAnchor).activate()
        postMetaInfoBottomView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        postMetaInfoBottomView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
    }
}
