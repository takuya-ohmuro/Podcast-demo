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
            miniTitleLabel.text = episode.title
            authorLabel.text = episode.author
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
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
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(1, 3)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationTimeLabel.text = durationTime?.toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSecond = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let percentage = currentTimeSeconds / durationSecond
        self.currentTimeSlider.value = Float(percentage)
    }
    var panGesture:UIPanGestureRecognizer!
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        observePlayerCurrentTime()
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        //player has a reference to self
        //self has a reference to player
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
        }
    }
    static func initFromNib() -> PlayerDetialsView {
        return Bundle.main.loadNibNamed("PlayerDetialsView", owner: self, options: nil)?.first as! PlayerDetialsView
    }
    
    deinit {
        print("PlayerDetelsView memory being reclaiming")
    }
    
    //MARK:- IB Action and outlet
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayParse), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniFastForwordButton: UIButton! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var minimizedStackView: UIStackView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBAction func handleCurrentSliderTimeChange(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconde = CMTimeGetSeconds(duration)
        let seekTimeSeconde = Float64(percentage) * durationSeconde
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconde, 1)
        player.seek(to: seekTime)
    }
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    fileprivate func seekToCurrentTime(delta:Int64) {
        let fifteenSeconde = CMTimeMake(delta, 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconde)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    @IBAction func handleDismissButton(_ sender: Any) {
//        self.removeFromSuperview()
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
        panGesture.isEnabled = true
        
    }
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }
    fileprivate func shirinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
            self.episodeImageView.transform = self.shrunkenTransform
        })
        
    }
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet{
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = self.shrunkenTransform
            
        }
    }
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
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        }else{
            player.pause()
            playpurseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shirinkEpisodeImageView()
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
}
