//
//  EpisodesController.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/28.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {
    
    var podcast:Podcast? {
        didSet {
            navigationItem.title = podcast?.artistName
        }
    }
    
    fileprivate let cellId = "cellId"
    struct Episode {
        let title:String
    }
    
    var episode = [
        Episode(title: "First Episode"),
        Episode(title: "Seconde Episode"),
        Episode(title: "Third Episode")
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    //MARK:- Setup work
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episode.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId , for: indexPath)
        let episode = self.episode[indexPath.row]
        cell.textLabel?.text = episode.title
        return cell
    }
}
