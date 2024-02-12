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
    let close: String
    let open: String
    let shopCatch: String
    let urls: Urls
    let stationName: String

    enum CodingKeys: String, CodingKey {
        case name
        case genre
        case photo
        case address
        case close
        case open
        case shopCatch = "catch"
        case urls
        case stationName = "station_name"
    }
}

struct Genre: Decodable {
    let name: String
    let genreCatch: String

    enum CodingKeys: String, CodingKey {
        case name
        case genreCatch = "catch"
    }
}

struct Photo: Decodable {
    let mobile: Mobile
}

struct Mobile: Decodable {
    let l: String
}

struct Urls: Decodable {
    let pc: String
}
