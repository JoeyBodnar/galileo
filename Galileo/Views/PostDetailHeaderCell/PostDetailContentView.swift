//
//  PostDetailContentView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient
import CocoaMarkdown

final class PostDetailContentView: NSTableCellView {
    
    let textView: NSTextView = NSTextView()
    private let imgView: ImageViewButton = ImageViewButton()
    private let videoView: VideoView = VideoView()
    
    private var imageViewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var imageViewWidthAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    private var videoViewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var videoViewWidthAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
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
    
    private func commmonInit() {
        layoutViews()
        setupViews()
    }
    
    func clear() {
        textView.textStorage?.setAttributedString(NSAttributedString(string: ""))
        setImageViewConstraintsToZero()
        videoViewWidthAnchor.constant = 0
        videoViewHeightAnchor.constant = 0
        videoView.clear()
    }
    
    func configureForSelfText(link: Link) {
        let doc = CMDocument(string: link.data.selftext ?? "-", options: CMDocumentOptions.hardBreaks)
        let renderer = CMAttributedStringRenderer(document: doc, attributes: CMTextAttributes())
        textView.textStorage?.setAttributedString(renderer!.render())
        
        textView.textColor = NSColor.textColor
        textView.font = CommentTableViewCellView.commentTextLabelFont
        
        setImageViewConstraintsToZero()
    }
    
    func configureForImage(link: Link) {
        textView.textStorage?.setAttributedString(NSAttributedString(string: ""))
        
        if let imgUrl = link.data.url {
            if imgUrl.contains("gif") {
                imgView.setGif(urlString: imgUrl)
            } else if let resolution = link.resolutionForPostDetail {
                let adjusted: String = resolution.urlRemovingSpecialCharacters
                imgView.setImage(with: adjusted)
            } else {
                imgView.setImage(with: imgUrl)
            }
        }
        
        let imgSize: NSSize = link.imgSizeForPostDetail
        
        let widthHeightRatio: CGFloat = imgSize.width / imgSize.height
        imageViewHeightAnchor.constant = imgSize.height
        imageViewWidthAnchor.constant = imgSize.height * (widthHeightRatio)
    }
    
    func configureForVideo(link: Link) {
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
        
        videoViewWidthAnchor.constant = size.width
        videoViewHeightAnchor.constant = size.height
        
        setImageViewConstraintsToZero()
    }
    
    private func setImageViewConstraintsToZero() {
        imageViewHeightAnchor.constant = 0
        imageViewWidthAnchor.constant = 0
    }
}

// MARK: - Layout/Setup
extension PostDetailContentView {
    
    private func setupViews() {
        textView.drawsBackground = false
        textView.isEditable = false
        textView.font = CommentTableViewCellView.commentTextLabelFont
        textView.textColor = NSColor.textColor
    }
    
    private func layoutViews() {
        textView.setupForAutolayout(superView: self)
        imgView.setupForAutolayout(superView: self)
        videoView.setupForAutolayout(superView: self)
        
        textView.pinToSides(superView: self)
        
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        imgView.topAnchor.constraint(equalTo: topAnchor).activate()
        imageViewHeightAnchor = imgView.heightAnchor.constraint(equalToConstant: 0)
        imageViewHeightAnchor.activate()
        imageViewWidthAnchor = imgView.widthAnchor.constraint(equalToConstant: 0)
        imageViewWidthAnchor.activate()
        
        videoView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        videoView.topAnchor.constraint(equalTo: topAnchor).activate()
        videoViewHeightAnchor = videoView.heightAnchor.constraint(equalToConstant: 0)
        videoViewHeightAnchor.activate()
        videoViewWidthAnchor = videoView.widthAnchor.constraint(equalToConstant: 0)
        videoViewWidthAnchor.activate()
    }
}
