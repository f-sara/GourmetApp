//
//  SearchResultViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/15.
//

import UIKit

// MARK: - SearchResultViewController

final class SearchResultViewController: UIViewController {


    // MARK: Internal Properties

    var genre: String?


    // MARK: Private Properties

    private var restaurantData: RestaurantDataModel?
    private var presenter: SearchResultPresenter!
    private var range: String = "1"
    private var selectedRange = MenuRangeType.range1

    // MARK: IBOutlets

    @IBOutlet @ViewLoading var errorMessageLabel: UILabel
    @IBOutlet @ViewLoading var indicatorView: UIActivityIndicatorView
    @IBOutlet @ViewLoading var collectionView: UICollectionView
    @IBOutlet @ViewLoading var rangeSelectionButton: UIButton


    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        self.presenter = SearchResultPresenter(output: self, apiClient: APIClient())
        collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        
        if let genre { presenter.viewAppear(genre: genre, range: range) }
        configureRange()
        errorMessageLabel.isHidden = true
    }

    private func configureRange() {
        let actions = MenuRangeType.allCases
            .compactMap { type in
                UIAction(
                    title: type.range,
                    state: type == selectedRange ? .on : .off,
                    handler: { _ in
                        self.selectedRange = type
                        self.configureRange()
                    })
            }
        rangeSelectionButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        rangeSelectionButton.showsMenuAsPrimaryAction = true
        rangeSelectionButton.setTitle(selectedRange.range, for: .normal)
        range = selectedRange.rangeValue
        if let genre { self.presenter.selectedRange(genre: genre,range: range) }
    }


    // MARK: Other Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGenreDetail" {
            let restaurantDetailViewController = segue.destination as! RestaurantDetailViewController
            restaurantDetailViewController.restaurantDetail = sender as? Shop
        }
    }
}


// MARK: - Extensions


// MARK: UICollectionViewDelegate, UICollectionViewDataSource

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
        cell.setUpUI(restaurantData: restaurantData, viewController: self)
        indicatorView.stopAnimating()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showGenreDetail", sender: self.restaurantData?.results.shop[indexPath.item])
    }

}


// MARK: UICollectionViewDelegateFlowLayout

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.bounds.width - 14) / 2
        let heightSize = widthSize * 1.3
        return CGSize(width: widthSize, height: heightSize)
    }
}


// MARK: SearchResultPresenterOutput

extension SearchResultViewController: SearchResultPresenterOutput {
    func showSearchResult(_ data: RestaurantDataModel) {
        self.restaurantData = data
        Task {
            self.collectionView.reloadData()
        }
    }

    func showError(_ error: APIError) {
        Task {
            ShowAlert.showAlert(title: error.errorTitle, massage: error.errorMessage, viewController: self)
        }
    }
}
