//
//  NewsObj.swift
//  news-engine
//
//  Created by Qodir Masruri on 02/08/21.
//

import Foundation

struct NewsObj{
    var title: String?
    var body: String?
    var user_name: String?
    var company_name: String?
}

struct Posts: Codable {
    let userId: Int
    let id: Int
    let title: String?
    let body: String?
}
