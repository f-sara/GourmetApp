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

enum MenuRangeType: CaseIterable {
    case range1
    case range2
    case range3
    case range4
    case range5

    var range: String {
        switch self {
        case .range1:
            return "300m"
        case .range2:
            return "500m"
        case .range3:
            return "1,000m"
        case .range4:
            return "2,000m"
        case .range5:
            return "3,000m"
        }
    }

    var rangeValue: String {
        switch self {
        case .range1:
            return "1"
        case .range2:
            return "2"
        case .range3:
            return "3"
        case .range4:
            return "4"
        case .range5:
            return "5"
        }
    }
}
