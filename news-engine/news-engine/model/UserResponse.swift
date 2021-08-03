//
//  UserResponse.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import Foundation

// MARK: - UserResponseElement
struct UserResponseElement: Codable{
    let id: Int?
    let name, username, email: String?
    let address: AddressElement?
    let phone, website: String?
    let company: CompanyElement?
}

struct AddressElement: Codable{
    let street, suite, city, zipcode: String?
    let geo: GeoElement?
    
    enum CodingKeys: String, CodingKey{
        case street, suite, city, zipcode
        case geo
    }
}

struct GeoElement: Codable{
    let lat, lng: String?
}

struct CompanyElement: Codable{
    let name, catchprase, bs: String?
}

typealias listUserResponse = [UserResponseElement]
