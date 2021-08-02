//
//  Utils.swift
//  news-engine
//
//  Created by Qodir Masruri on 02/08/21.
//

import Foundation
import Alamofire

class Utils: NSObject{
    static func generateAuthHeader() -> HTTPHeaders? {
        return ["Content-Type": "application/json",
                "Cache-Control": "no-cache"
        ]
    }
}
