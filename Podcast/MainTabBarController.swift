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
        
    }
    
    //MARK:- setup Functions
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
