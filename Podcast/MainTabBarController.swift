//
//  MainTabBarController.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/28.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple
        setupViewControls()
        
        setupPlayerDetailsView()
        
//        perform(#selector(maximizePlayerDetials), with: nil, afterDelay: 1)
    }
    
    @objc func minimizePlayerDetails() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        })
    }
     func maximizePlayerDetials(episode:Episode?) {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = 0
        if episode != nil {
            playerDetailsView.episode = episode
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
        })
    }
    
    
    //MARK:- setup Functions
    var maximizedTopAnchorConstraint:NSLayoutConstraint!
    var minimizedTopAnchorConstraint:NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    let playerDetailsView = PlayerDetialsView.initFromNib()
    fileprivate func setupPlayerDetailsView() {
        print("Setting up PlayerDetailsView")
        
        //playerDetailsView.frame = view.frame
        //Use auto layout
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        //enables auto layout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTopAnchorConstraint.isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    
    func setupViewControls() {
        viewControllers = [
            generalNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generalNavigationController(for: ViewController(), title: "Favorite", image: #imageLiteral(resourceName: "favorites")),
            generalNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    //MARK:- Helper Function
    
    fileprivate func generalNavigationController(for rootViewController:UIViewController,title:String,image:UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
}
