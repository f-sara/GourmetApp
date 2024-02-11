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
    @IBOutlet @ViewLoading var shopImage: UIImageView

    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantDetailInfo = restaurantDetail{
            shopNameLabel.text = restaurantDetailInfo.name
            addressLabel.text = restaurantDetailInfo.address
            catchLabel.text = restaurantDetailInfo.shopCatch
            buildImage(urlString: restaurantDetailInfo.photo.mobile.l) { image in
                if let image {
                    DispatchQueue.main.async {
                        self.shopImage.image = image
                    }
                } else {
                    print("画像表示エラー")
                }
            }
        } else {
            shopNameLabel.text = "なし"
        }
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
