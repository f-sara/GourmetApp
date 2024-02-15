//
//  SearchPresenter.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/13.
//

import Foundation

protocol SearchPresenterInput: AnyObject {
    func tappedGenre(latitude: Double, longitude: Double, keyword: String)
}

protocol SearchPresenterOutput: AnyObject {
    func showSearchResult(_ data: RestaurantDataModel)
    func showError(error: Error)
}

final class SearchPresenter {
    private weak var output: SearchPresenterOutput!
    private var apiClient: APIClient!

    init(output: SearchPresenterOutput!, apiClient: APIClient!, restaurantDataModel: [Shop]) {
        self.output = output
        self.apiClient = apiClient
    }
}

extension SearchPresenter: SearchPresenterInput {
    func tappedGenre(latitude: Double, longitude: Double, keyword: String) {
        apiClient.fetchRestaurantData(latitude: latitude, longitude: longitude, keyword: keyword, range: "3") { [weak self]  result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let restaurantData):
                self.output?.showSearchResult(restaurantData)
            case .failure(let error):
                self.output?.showError(error: error)
            }
        }
    }
    

}
