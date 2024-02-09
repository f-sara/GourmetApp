//
//  RestaurantDetailViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/09.
//

import Foundation
import UIKit

final class RestaurantDetailViewController: UIViewController {

    var restaurantInfo: Shop?

    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = restaurantInfo?.name {
            shopName.text = name
        } else {
            shopName.text = "なし"
        }
    }

}
