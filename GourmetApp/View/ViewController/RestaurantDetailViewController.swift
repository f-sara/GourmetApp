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

    @IBOutlet @ViewLoading var shopName: UILabel
    @IBOutlet @ViewLoading var shopImage: UIImageView

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = restaurantDetail?.name {
            shopName.text = name
        } else {
            shopName.text = "なし"
        }
    }

}
