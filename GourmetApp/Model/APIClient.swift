//
//  APIClient.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import Foundation

final class APIClient {
    
    func fetchRestaurantData(keyword: String?, range: String, genre: String?, completion: @escaping (Result<RestaurantDataModel, APIError>) -> Void) {
        let apiURL = createAPIURL(keyword: keyword, range: range, genre: genre)

        guard let url = apiURL else {
            completion(.failure(APIError.failCreateURL))
            return
        }
        
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
                } catch let error {
                    completion(.failure(APIError.decodeError(error)))
                }
                
            }
            urlSessionTask.resume()
        }
    }
    
    private func createAPIURL(keyword: String?, range: String, genre: String?) -> URL? {
        let baseURL: URL? = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1")
        let apiKey = ProcessInfo.processInfo.environment["apiKey"]
        let format = "json"
        var urlComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: HomeViewController.latitude.description),
            URLQueryItem(name: "lng", value: HomeViewController.longitude.description),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "range", value: range),
        ]
        
        if let keyword {
            queryItems.append(URLQueryItem(name: "keyword", value: keyword))
        }

        if let genre {
            queryItems.append(URLQueryItem(name: "genre", value: genre))
        }

        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    
    private func decodeAPIResponse(responseData: Data) throws -> RestaurantDataModel {
        let decoder = JSONDecoder()
        let restaurantData = try decoder.decode(RestaurantDataModel.self, from: responseData)
        return restaurantData
    }
}
