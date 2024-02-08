//
//  ViewController.swift -> HomeViewController
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/03.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    private var presenter: HomePresenter!
    private var restaurantData: RestaurantDataModel?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        presenter = HomePresenter(output: self, model: HomeModel())
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }

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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as! RecommendCollectionViewCell
        if let name = self.restaurantData?.results.shop[indexPath.item].name,
           let genre = self.restaurantData?.results.shop[indexPath.item].genre.name{
            cell.nameLabel.text = name
            cell.genreLabel.text = genre
            return cell

        } else {
            cell.nameLabel.text = ""
            cell.genreLabel.text = ""
            return cell
        }
    }
}

// スタイルの変更
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
