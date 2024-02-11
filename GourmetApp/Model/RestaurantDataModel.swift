//
//  RestaurantDataModel.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

struct RestaurantDataModel: Decodable {
    let results: Results
}

struct Results: Decodable {
    let shop: [Shop]
}

struct Shop: Decodable {
    let name: String
    let genre: Genre
    let photo: Photo
    let address: String
    let open: String
    let close: String
    let shopCatch: String

    enum CodingKeys: String, CodingKey {
        case name
        case genre
        case photo
        case address
        case open
        case close
        case shopCatch = "catch"
    }
}

struct Genre: Decodable {
    let name: String
}

struct Photo: Decodable {
    let mobile: Mobile
}

struct Mobile: Decodable {
    let l: String
}

