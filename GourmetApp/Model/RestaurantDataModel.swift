//
//  RestaurantDataModel.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import Foundation

struct RestaurantDataModel: Codable {
    let results: Results
}

struct Results: Codable {
    let shop: [Shop]
}

struct Shop: Codable {
    let name: String // 店の名前
    let genre: Genre
    let photo: Photo
}

struct Genre: Codable {
    let name: String // ジャンル
}

struct Photo: Codable {
    let mobile: Mobile
}


struct Mobile: Codable {
    let l: String // 携帯用のトップ写真
}
