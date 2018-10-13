//
//  News.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 1/7/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import Foundation

class News {
    let priority: Int   // 1 - 9, from high to low
    let title: String
    let description: String
    var source: String?
    var imageUrl: String?
    
    init(priority: Int = 9, title: String, description: String, source: String? = nil, imageUrl: String? = nil) {
        self.priority = priority
        self.title = title
        self.description = description
        self.source = source
        self.imageUrl = imageUrl
    }
}
