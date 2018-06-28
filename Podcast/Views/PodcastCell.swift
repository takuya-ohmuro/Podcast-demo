//
//  PodcastCell.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/28.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell:UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var EpsodeCountLabel: UILabel!
    
    
    var podcast:Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            EpsodeCountLabel.text = "\(podcast.trackCount ?? 0) Episode"
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }

            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
