//
//  RestaurantDetailViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/09.
//

import Foundation
import UIKit

final class RestaurantDetailViewController: UIViewController {

    var restaurantDetail: Shop?

    @IBOutlet @ViewLoading var shopNameLabel: UILabel
    @IBOutlet @ViewLoading var addressLabel: UILabel
    @IBOutlet @ViewLoading var catchLabel: UILabel
    @IBOutlet @ViewLoading var subCatchLabel: UILabel
    @IBOutlet @ViewLoading var shopImage: UIImageView
    @IBOutlet @ViewLoading var genreLabel: UILabel
    @IBOutlet @ViewLoading var openLabel: UILabel

    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantDetailInfo = restaurantDetail {
            shopNameLabel.text = restaurantDetailInfo.name
            addressLabel.text = restaurantDetailInfo.address
            catchLabel.text = restaurantDetailInfo.genre.genreCatch
            subCatchLabel.text = restaurantDetailInfo.shopCatch
            genreLabel.text = restaurantDetailInfo.genre.name
            openLabel.text = restaurantDetailInfo.open
            showImage(imageUrl: restaurantDetailInfo.photo.mobile.l)
        }
    }

    @IBAction func openWebSite(_ sender: UIButton) {
        if let restaurantURL = restaurantDetail?.urls.pc {
            guard let url = URL(string: restaurantURL) else {return}
            UIApplication.shared.open(url)
        }
    }

    private func showImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print(error)
                return
            }

            if let data = data,
               let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self?.shopImage.image = image
                }
            } else {
                print("画像表示エラー")
            }
        }.resume()
    }

}
