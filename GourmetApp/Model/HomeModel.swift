//
//  APIClient.swift -> HomeModel.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import Foundation

final class HomeModel {
    
    func fetchRestaurantData(latitude: Double, longitude: Double, keyword: String?, range: String, completion: @escaping (Result<RestaurantDataModel, APIError>) -> Void) {
        let apiURL = createAPIURL(latitude: latitude, longitude: longitude, keyword: keyword, range: range)

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
    
    private func createAPIURL(latitude: Double, longitude: Double, keyword: String?, range: String) -> URL? {
        let baseURL: URL? = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1")
        let apiKey = ProcessInfo.processInfo.environment["apiKey"]
        let format = "json"
        var urlComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: latitude.description),
            URLQueryItem(name: "lng", value: longitude.description),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "range", value: range),
        ]
        
        if let keyword {
            queryItems.append(URLQueryItem(name: "keyword", value: keyword))
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
