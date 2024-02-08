//
//  HomePresenter.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import Foundation

protocol HomePresenterInput: AnyObject {
    func fetchRestaurantData(latitude: Double, longitude: Double, keyword: String?)
}

protocol HomePresenterOutput: AnyObject {
    func updateUI(_ restaurantModel: RestaurantDataModel?)
    func showError(error: Error)
}

final class HomePresenter {
    private weak var output: HomePresenterOutput?
    private var model = HomeModel()

    init(output: HomePresenterOutput, model: HomeModel) {
        self.output = output
        self.model = model
    }
}

extension HomePresenter: HomePresenterInput {
    func fetchRestaurantData(latitude: Double, longitude: Double, keyword: String?) {
        model.fetchRestaurantData(latitude: latitude, longitude: longitude, keyword: keyword) { [weak self]  result in
            guard let self = self else {
                print("参照エラー")
                return
            }
            switch result {
            case .success(let restaurantData):
                print(restaurantData)
                self.output?.updateUI(restaurantData)
            case .failure(let error):
                self.output?.showError(error: error)
            }
        }
    }

}