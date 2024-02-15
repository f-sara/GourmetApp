//
//  ViewController.swift -> HomeViewController
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/03.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController, UISearchBarDelegate {
    private let locationManager = CLLocationManager()
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0

    private var presenter: HomePresenter!
    private var restaurantData: RestaurantDataModel?
    private var restaurantImage: [UIImage] = []
    private var range: String = "1"
    private var permissionLocation: Bool = false

    @IBOutlet @ViewLoading var searchBar: UISearchBar
    @IBOutlet @ViewLoading var indicatorView: UIActivityIndicatorView
    @IBOutlet @ViewLoading var collectionView: UICollectionView
    @IBOutlet @ViewLoading var selectedRangeButton: UIButton
    @IBOutlet @ViewLoading var errorMessageLabel: UILabel
    @IBOutlet @ViewLoading var openSettingButton: UIButton

    private var selectedRange = MenuRangeType.range1

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        presenter = HomePresenter(output: self, model: APIClient())
        locationManager.delegate = self
        searchBar.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        collectionView.keyboardDismissMode = .onDrag
        locationManager.requestWhenInUseAuthorization()
        configureRange()
        errorMessageLabel.isHidden = true
        openSettingButton.isHidden = true
    }

    @IBAction func openSetting() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        selectedRangeButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        selectedRangeButton.showsMenuAsPrimaryAction = true
        selectedRangeButton.setTitle(selectedRange.range, for: .normal)
        range = selectedRange.rangeValue
        if permissionLocation == true {
            self.presenter.fetchRestaurantData(latitude: latitude, longitude: longitude, keyword: nil, range: range)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let restaurantDetailViewController = segue.destination as! RestaurantDetailViewController
            restaurantDetailViewController.restaurantDetail = sender as? Shop
        }
    }

    private func searchBarClose(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let word = searchBar.text {
            self.presenter.fetchRestaurantData(latitude: latitude, longitude: longitude, keyword: word, range: range)
        }
    }

    private func showAlert(title: String, massage: String, buttonAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = buttonAction
        let cancel = UIAlertAction(title: "閉じる", style: .cancel, handler: { (action) -> Void in })
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

}

extension HomeViewController: HomePresenterOutput {
    func updateUI(_ restaurantModel: RestaurantDataModel?) {
        self.restaurantData = restaurantModel
        self.restaurantImage = []
        Task {
            self.collectionView.reloadData()
        }
    }

    func showError(error: Error) {
        print(error)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            self.presenter.fetchRestaurantData(latitude: self.latitude, longitude: self.longitude, keyword: nil, range: range)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationManager.requestLocation()
            permissionLocation = true
            errorMessageLabel.isHidden = true
            openSettingButton.isHidden = true
        default:
            errorMessageLabel.text = "位置情報の利用が許可されていません"
            indicatorView.stopAnimating()
            errorMessageLabel.isHidden = false
            openSettingButton.isHidden = false
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        self.performSegue(withIdentifier: "showDetail", sender: self.restaurantData?.results.shop[indexPath.item])
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.bounds.width - 14) / 2
        let heightSize = widthSize * 1.3
        return CGSize(width: widthSize, height: heightSize)
    }
}
