//
//  HomePresenter.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

// MARK: - Protocols

protocol HomePresenterInput: AnyObject {
    func appearedView(range: String)
    func confirmSearchBar(keyword: String, range: String)
}

protocol HomePresenterOutput: AnyObject {
    func updateUI(_ restaurantModel: RestaurantDataModel?)
    func showError(error: APIError)
}


// MARK: - HomePresenter

final class HomePresenter {


    // MARK: Private Properties

    private weak var output: HomePresenterOutput!
    private var model: APIClient!


    // MARK: Initializers

    init(output: HomePresenterOutput, model: APIClient) {
        self.output = output
        self.model = model
    }


    // MARK: Internal Methods

    func fetchRestaurantData(keyword: String?, range: String) {
        model.fetchRestaurantData(keyword: keyword, range: range, genre: nil) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let restaurantData):
                self.output?.updateUI(restaurantData)
            case .failure(let error):
                self.output?.showError(error: error)
            }
        }
    }
}


// MARK: - Extensions 


// MARK: HomePresenterInput

extension HomePresenter: HomePresenterInput {
    func appearedView(range: String) {
        fetchRestaurantData(keyword: nil, range: range)
    }

    func confirmSearchBar(keyword: String, range: String) {
        fetchRestaurantData(keyword: keyword, range: range)
    }

}
