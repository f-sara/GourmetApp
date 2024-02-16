//
//  SearchPresenter.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/13.
//

// MARK: - Protocols

protocol SearchResultPresenterInput: AnyObject {
    func viewAppear(genre: String, range: String)
    func selectedRange(genre: String, range: String)
}

protocol SearchResultPresenterOutput: AnyObject {
    func showSearchResult(_ data: RestaurantDataModel)
    func showError(_ error: APIError)
}


// MARK: - SearchResultPresenter

final class SearchResultPresenter {


    // MARK: Private Properties

    private weak var output: SearchResultPresenterOutput!
    private var apiClient: APIClient!


    // MARK: Initializers

    init(output: SearchResultPresenterOutput!, apiClient: APIClient!) {
        self.output = output
        self.apiClient = apiClient
    }


    // MARK: Private Methods

    private func fetchRestaurantData(genre: String, range: String) {
        apiClient.fetchRestaurantData(keyword: nil, range: range, genre: genre) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurantData):
                self.output?.showSearchResult(restaurantData)
            case .failure(let error):
                self.output?.showError(error)
            }
        }
    }
}


// MARK: - Extensions


// MARK: SearchResultPresenterInput

extension SearchResultPresenter: SearchResultPresenterInput {
    func viewAppear(genre: String, range: String) {
        fetchRestaurantData(genre: genre, range: range)
    }

    func selectedRange(genre: String, range: String) {
        fetchRestaurantData(genre: genre, range: range)
    }

}
