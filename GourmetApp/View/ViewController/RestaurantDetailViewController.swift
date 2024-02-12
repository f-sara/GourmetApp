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
    @IBOutlet @ViewLoading var subCatchLabel: UILabel
    @IBOutlet @ViewLoading var shopImage: UIImageView
    @IBOutlet @ViewLoading var genreLabel: UILabel
    @IBOutlet @ViewLoading var openLabel: UILabel

    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantDetailInfo = restaurantDetail.0,
           let restaurantDetailImage = restaurantDetail.1 {
            shopNameLabel.text = restaurantDetailInfo.name
            addressLabel.text = restaurantDetailInfo.address
            catchLabel.text = restaurantDetailInfo.genre.genreCatch
            subCatchLabel.text = restaurantDetailInfo.shopCatch
            genreLabel.text = restaurantDetailInfo.genre.name
//            openLabel.text = "定休日：\(restaurantDetailInfo.close)"
            openLabel.text = restaurantDetailInfo.open
            shopImage.image = restaurantDetailImage
        }
    }

    @IBAction func openWebSite(_ sender: UIButton) {
        if let restaurantURL = restaurantDetail.0?.urls.pc {
            guard let url = URL(string: restaurantURL) else {return}
            UIApplication.shared.open(url)
        }
    }

}
