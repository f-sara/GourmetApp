//
//  RestaurantDetailViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/09.
//

import Foundation
import UIKit

final class RestaurantDetailViewController: UIViewController {

    //    var restaurantDetail: Shop?
    var restaurantDetail: (Shop?, UIImage?)

    @IBOutlet @ViewLoading var shopNameLabel: UILabel
    @IBOutlet @ViewLoading var addressLabel: UILabel
    @IBOutlet @ViewLoading var catchLabel: UILabel
    @IBOutlet @ViewLoading var shopImage: UIImageView

    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantDetailInfo = restaurantDetail.0,
           let restaurantDetailImage = restaurantDetail.1 {
            shopNameLabel.text = restaurantDetailInfo.name
            addressLabel.text = restaurantDetailInfo.address
            catchLabel.text = restaurantDetailInfo.shopCatch
            shopImage.image = restaurantDetailImage
        } else {
            shopNameLabel.text = "なし"
        }
    }

}
