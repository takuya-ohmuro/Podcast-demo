//
//  extention.swift
//  Podcast
//
//  Created by takuyaOhmuro on 2018/06/29.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
