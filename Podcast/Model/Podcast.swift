//
//  Podcast.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/28.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation


struct Podcast:Decodable {
    var trackName:String?
    var artistName:String?
    var artworkUrl600:String?
    var trackCount:Int?
    var feedUrl:String?
}
