//
//  NewsItem.swift
//  brichios
//
//  Created by Mac Mini 2 on 5/12/2024.
//

import Foundation

struct NewsItem : Codable, Identifiable{
    var id : String
    var title : String
    var content : String
    var link : String
    var date : String
}
