//
//  APIClient.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import Foundation

final class HomeModel {

    func fetchRestaurantData(latitude: Double, longitude: Double, keyword: String?, completion: @escaping (Result<RestaurantDataModel, APIError>) -> Void) {
        let apiURL = createAPIURL(latitude: latitude, longitude: longitude, keyword: keyword)

        guard let url = apiURL else {
            completion(.failure(APIError.failCreateURL))
            return
        }
        print(url)

        Task.detached {
            let urlSessionTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data else {
                    completion(.failure(APIError.sessionError))
                    return
                }

                if let error {
                    completion(.failure(APIError.requestError(error)))
                    return
                }

                do {
                    let responseData = try self.decodeAPIResponse(responseData: data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(APIError.decodeError))
                }

            }
            urlSessionTask.resume()
        }
    }

    func createAPIURL(latitude: Double, longitude: Double, keyword: String?) -> URL? {
        let baseURL: URL? = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1")
        let apiKey = ProcessInfo.processInfo.environment["apiKey"]
        let format = "json"

        var urlComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)

        if let keyword {
            urlComponents?.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "lat", value: latitude.description),
                URLQueryItem(name: "lng", value: longitude.description),
                URLQueryItem(name: "keyword", value: keyword),
                URLQueryItem(name: "format", value: format)
            ]
        } else {
            urlComponents?.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "lat", value: latitude.description),
                URLQueryItem(name: "lng", value: longitude.description),
                URLQueryItem(name: "format", value: format)
            ]
        }
        return urlComponents?.url
    }

    func decodeAPIResponse(responseData: Data) throws -> RestaurantDataModel {
        let decoder = JSONDecoder()
        let restaurantData = try decoder.decode(RestaurantDataModel.self, from: responseData)
        return restaurantData
    }
    
}

enum APIError: Error {
    case failCreateURL
    case sessionError
    case requestError(Error)
    case decodeError
}

extension Notification.Name {
    static let processDidFinish = Notification.Name("processDidFinish")
}
