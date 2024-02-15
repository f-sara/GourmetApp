//
//  SearchResultViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/15.
//

import UIKit

final class SearchResultViewController: UIViewController {

    private var latitude: Double = 35.7020691
    private var longitude: Double = 139.7753269
    private var restaurantData: RestaurantDataModel?

    private var presenter: SearchResultPresenter!

    var genre: String?

    @IBOutlet @ViewLoading var errorMessageLabel: UILabel
    @IBOutlet @ViewLoading var indicatorView: UIActivityIndicatorView
    @IBOutlet @ViewLoading var collectionView: UICollectionView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = SearchResultPresenter(output: self, apiClient: APIClient())
        collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        if let genre {
            presenter.viewAppear(latitude: latitude, longitude: longitude, genre: genre)
        }
        errorMessageLabel.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGenreDetail" {
            let restaurantDetailViewController = segue.destination as! RestaurantDetailViewController
            restaurantDetailViewController.restaurantDetail = sender as? Shop
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let shopCount = self.restaurantData?.results.shop.count {
            if shopCount == 0 && errorMessageLabel.isHidden == true {
                indicatorView.stopAnimating()
                errorMessageLabel.text = "お店が見つかりませんでした"
                errorMessageLabel.isHidden = false
            } else if shopCount >= 1 {
                errorMessageLabel.isHidden = true
            }
            return shopCount
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCollectionViewCell,
              let restaurantData = self.restaurantData?.results.shop[indexPath.item] else {
            return RecommendCollectionViewCell()
        }
        cell.setUp(restaurantData: restaurantData)
        indicatorView.stopAnimating()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showGenreDetail", sender: self.restaurantData?.results.shop[indexPath.item])
    }

}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.bounds.width - 14) / 2
        let heightSize = widthSize * 1.3
        return CGSize(width: widthSize, height: heightSize)
    }
}


extension SearchResultViewController: SearchResultPresenterOutput {
    func showSearchResult(_ data: RestaurantDataModel) {
        self.restaurantData = data
        Task {
            self.collectionView.reloadData()
        }
    }

    func showError(error: Error) {
        //
    }


}
