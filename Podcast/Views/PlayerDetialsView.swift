//
//  PlayerDetialsView.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/29.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class PlayerDetialsView: UIView {
    
    var episode:Episode! {
        didSet {
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            playEpisode()
        }
    }
    fileprivate func playEpisode() {
        print("Trying to play episode at url:",episode.streamUrl)
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    let player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    //MARK:- IB Action and outlet
    @IBAction func handleDismissButton(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var playpurseButton: UIButton! {
        didSet {
            playpurseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playpurseButton.addTarget(self, action: #selector(handlePlayParse), for: .touchUpInside)
        }
    }
    @objc func handlePlayParse() {
        print("Trying to play and parse")
        if player.timeControlStatus == .paused {
            player.play()
            playpurseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else{
            player.pause()
            playpurseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
}
