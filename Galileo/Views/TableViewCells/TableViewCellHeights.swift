//
//  TableViewCellHeights.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class TableViewCellHeights {
    
    static func linkCellHeight(_ tableView: NSTableView, link: Link, heightOfRow row: Int) -> CGFloat {
        let linkType: LinkType = LinkType(link: link)
        switch linkType {
        case .linkedArticle, .selfText:
            return LinkArticleCell.height(link: link, width: tableView.frame.width - LinkCellConstants.voteViewSize.width - 8)
        case .imageReddit, .imageImgur, .gifImgur:
            return LinkImageCell.height(link: link, width: tableView.frame.width - LinkCellConstants.voteViewSize.width - 8)
        case .hostedVideo, .youtubeVideo, .gyfcatVideo, .richVideoGeneric:
            return LinkVideoCell.height(link: link, width: tableView.frame.width - LinkCellConstants.voteViewSize.width - 8)
        }
    }
}
