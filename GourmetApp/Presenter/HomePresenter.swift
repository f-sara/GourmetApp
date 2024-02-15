//
//  HomePresenter.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import Foundation

protocol HomePresenterInput: AnyObject {
    func fetchRestaurantData(keyword: String?, range: String)
}

protocol HomePresenterOutput: AnyObject {
    func updateUI(_ restaurantModel: RestaurantDataModel?)
    func showError(error: APIError)
}

final class HomePresenter {
    private weak var output: HomePresenterOutput?
    private var model = APIClient()

    init(output: HomePresenterOutput, model: APIClient) {
        self.output = output
        self.model = model
    }
}

extension HomePresenter: HomePresenterInput {
    func fetchRestaurantData(keyword: String?, range: String) {
        model.fetchRestaurantData(keyword: keyword, range: range, genre: nil) { [weak self]  result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let restaurantData):
                self.output?.updateUI(restaurantData)
            case .failure(let error):
                self.output?.showError(error: error)
            }
        }
    }

}
