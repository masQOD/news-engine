//
//  Constants.swift
//  news-engine
//
//  Created by Qodir Masruri on 02/08/21.
//

import Foundation

struct Contants{
    
    struct BaseApi{
        static let Root = "http://jsonplaceholder.typicode.com"
    }
    
    struct Endpoints{
        static let urlPosts = BaseApi.Root + "/posts"
        static let urlComments = BaseApi.Root + "/comments"
        static let urlAlbums = BaseApi.Root + "/albums"
        static let urlPhotos = BaseApi.Root + "/photos"
        static let urlUsers = BaseApi.Root + "/users"
    }
}
