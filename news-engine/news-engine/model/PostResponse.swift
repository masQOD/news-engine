//
//  PostResponse.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import Foundation

// MARK: - PostResponseElement
struct PostResponseElement: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}

typealias ListPostsResponse = [PostResponseElement]
