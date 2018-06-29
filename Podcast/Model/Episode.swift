//
//  Episode.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/29.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    let title:String
    let putData:Date
    let description:String
    var imageUrl:String?
    let author:String
    let streamUrl:String
    init(feedItem:RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        
        self.title = feedItem.title ?? ""
        self.putData = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
}
