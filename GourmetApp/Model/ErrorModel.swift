//
//  ErrorModel.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/08.
//

enum APIError: Error {
    case failCreateURL
    case sessionError
    case requestError(Error)
    case decodeError
}

enum DataError: Error {
    case imageError
}
