//
//  SearchPresenter.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/13.
//

// MARK: - Protocols

protocol SearchResultPresenterInput: AnyObject {
    func viewAppear(genre: String)
}

protocol SearchResultPresenterOutput: AnyObject {
    func showSearchResult(_ data: RestaurantDataModel)
    func showError(error: APIError)
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

    private func fetchRestaurantData(genre: String) {
        apiClient.fetchRestaurantData(keyword: nil, range: "3", genre: genre) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurantData):
                self.output?.showSearchResult(restaurantData)
            case .failure(let error):
                self.output?.showError(error: error)
            }
        }
    }
}


// MARK: - Extensions


// MARK: SearchResultPresenterInput

extension SearchResultPresenter: SearchResultPresenterInput {

    func viewAppear(genre: String) {
        fetchRestaurantData(genre: genre)
    }
}
