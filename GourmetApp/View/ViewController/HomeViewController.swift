//
//  ViewController.swift -> HomeViewController
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/03.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0

    private var presenter: HomePresenter!
    private var restaurantData: RestaurantDataModel?

    @IBOutlet @ViewLoading var searchBar: UISearchBar
    @IBOutlet @ViewLoading var indicatorView: UIActivityIndicatorView
    @IBOutlet @ViewLoading var collectionView: UICollectionView

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        presenter = HomePresenter(output: self, model: HomeModel())
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        collectionView.keyboardDismissMode = .onDrag
        locationManager.requestWhenInUseAuthorization()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let restaurantDetailViewController = segue.destination as! RestaurantDetailViewController
            restaurantDetailViewController.restaurantInfo = sender as? Shop
        }
    }

    private func searchBarClose(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    private func buildImage(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString else {
            completion(nil)
            return
        }

        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension HomeViewController: HomePresenterOutput {
    func updateUI(_ restaurantModel: RestaurantDataModel?) {
        self.restaurantData = restaurantModel
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
            self.presenter.fetchRestaurantData(latitude: self.latitude, longitude: self.longitude, keyword: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationManager.requestLocation()
        default:
            print("位置情報サービスの利用が許可されていません。")
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let shopCount = self.restaurantData?.results.shop.count {
            return shopCount
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as! RecommendCollectionViewCell
        if let name = self.restaurantData?.results.shop[indexPath.item].name,
           let genre = self.restaurantData?.results.shop[indexPath.item].genre.name,
           let imageURL = self.restaurantData?.results.shop[indexPath.item].photo.mobile.l{
            cell.nameLabel.text = name
            cell.genreLabel.text = genre
            buildImage(urlString: imageURL) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.shopImage.image = image
                    }
                } else {
                    print("画像表示エラー")
                }
            }
            indicatorView.stopAnimating()
            return cell

        } else {
            cell.nameLabel.text = ""
            cell.genreLabel.text = ""
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self.restaurantData?.results.shop[indexPath.item])
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10 , left: 2 , bottom: 10 , right: 2 )
    }

    // セルの左右
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    // セルの上下
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.bounds.width - 14) / 2
        let heightSize = widthSize * 1.3
        return CGSize(width: widthSize, height: heightSize)
    }
}
