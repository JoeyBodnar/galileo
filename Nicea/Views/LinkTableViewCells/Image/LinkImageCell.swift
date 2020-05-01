//
//  LinkImageCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class LinkImageCell: LinkParentCell {
    
    // imageView is already a property on NSTableCellView...
    let imgView: ImageViewButton = ImageViewButton()
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
        imgView.image = nil
        imgView.indicator.alphaValue = 0
        imgView.indicator.stopAnimation(self)
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    override func configure(link: Link) {
        super.configure(link: link)
        if let imgUrl = link.data.url {
            if imgUrl.contains("gif") {
                imgView.setGif(urlString: imgUrl)
            } else if let resolution = link.resolutionForCell {
                let adjusted: String = resolution.urlRemovingSpecialCharacters
                imgView.setImage(with: adjusted)
            } else {
                imgView.setImage(with: imgUrl)
            }
        }
        
        let imgSize: NSSize = link.imgSizeForCell
        
        let widthHeightRatio: CGFloat = imgSize.width / imgSize.height
        imageViewHeightAnchor.constant = link.imgSizeForCell.height
        imageViewWidthAnchor.constant = imgSize.height * (widthHeightRatio)
    }
    
    @objc func imagePressed() {
        guard let unwrappedImage = imgView.image else { return }
        delegate?.linkParentCell(self, didSelectImage: unwrappedImage)
    }
}

extension LinkImageCell {
    
    static func height(link: Link, width: CGFloat) -> CGFloat {
        let minHeight: CGFloat = 70
        let metaTopHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let metaBottomHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let padding: CGFloat = 2 + LinkCellConstants.mediaContentSpacingToTitle
        
        let dummyTextField: NSTextField = NSTextField()
        dummyTextField.usesSingleLineMode = false
        dummyTextField.isEditable = false
        let titleHeight: CGFloat = dummyTextField.bestHeight(for: link.data.title, width: width, font: LinkCellConstants.titleLabelFont)
        let imageHeight: CGFloat = link.imgSizeForCell.height
        let proposedHeight: CGFloat = titleHeight + padding + metaTopHeight + metaBottomHeight + imageHeight
    
        return minHeight > proposedHeight ? minHeight : proposedHeight
    }
}

extension LinkImageCell {
    
    private func setupViews() {
        imgView.target = self
        imgView.action = #selector(imagePressed)
    }
    
    private func layoutViews() {
        upvoteDownvoteView.setupForAutolayout(superView: self)
        postMetaInfoView.setupForAutolayout(superView: self)
        postMetaInfoBottomView.setupForAutolayout(superView: self)
        titleLabel.setupForAutolayout(superView: self)
        imgView.setupForAutolayout(superView: self)
        
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
        
        imgView.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        imgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LinkCellConstants.mediaContentSpacingToTitle).activate()
        imageViewHeightAnchor = imgView.heightAnchor.constraint(equalToConstant: 300)
        imageViewHeightAnchor.activate()
        
        imageViewWidthAnchor = imgView.widthAnchor.constraint(equalToConstant: 300)
        imageViewWidthAnchor.activate()
        
        postMetaInfoBottomView.leadingAnchor.constraint(equalTo: postMetaInfoView.leadingAnchor).activate()
        postMetaInfoBottomView.trailingAnchor.constraint(equalTo: postMetaInfoView.trailingAnchor).activate()
        postMetaInfoBottomView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        postMetaInfoBottomView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
    }
}
