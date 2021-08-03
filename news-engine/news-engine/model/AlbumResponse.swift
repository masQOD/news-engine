//
//  AlbumResponse.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import Foundation

// MARK: - AlbumResponse
struct AlbumResponseElement: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
}

typealias ListAlbumsResponse = [AlbumResponseElement]

// MARK: - PhotoResponse
struct PhotoResponseElement: Codable{
    let albumId: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

typealias ListPhotosResponse = [PhotoResponseElement]
