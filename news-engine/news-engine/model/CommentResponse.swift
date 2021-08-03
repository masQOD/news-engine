//
//  CommentResponse.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import Foundation

// MARK: - CommentResponse
struct CommentResponseElement: Codable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
}

typealias ListCommentsResponse = [CommentResponseElement]
