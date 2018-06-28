//
//  APIService.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/28.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    let baseiTunesUrl = "https://itunes.apple.com/search"
    //singleton
    static let shared = APIService()
    
    func fetchPodcasts(searchText:String,completionHandler: @escaping ([Podcast]) -> ()) {
    
        let parameters = ["term":searchText,"media":"podcast"]
        Alamofire.request(baseiTunesUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataresponse) in
            if let err = dataresponse.error {
                print("Faild to contact yahoo",err)
                return
            }
            guard let data = dataresponse.data else { return }
            do {
                
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
               
                completionHandler(searchResults.results)
//                self.podcast = searchResults.results
//                self.tableView.reloadData()
                
            } catch let decodeErr {
                print("Faild to decode:",decodeErr)
            }
        }
        
    }
    struct SearchResults:Decodable{
        let resultCount:Int
        let results:[Podcast]
    }
    
}
