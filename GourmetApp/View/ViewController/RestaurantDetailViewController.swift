//
//  RestaurantDetailViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/09.
//

import UIKit

// MARK: - RestaurantDetailViewController

final class RestaurantDetailViewController: UIViewController {


    // MARK: Properties

    var restaurantDetail: Shop?


    // MARK: IBOutlets

    @IBOutlet @ViewLoading var shopNameLabel: UILabel
    @IBOutlet @ViewLoading var addressLabel: UILabel
    @IBOutlet @ViewLoading var catchLabel: UILabel
    @IBOutlet @ViewLoading var subCatchLabel: UILabel
    @IBOutlet @ViewLoading var shopImage: UIImageView
    @IBOutlet @ViewLoading var genreLabel: UILabel
    @IBOutlet @ViewLoading var openLabel: UILabel


    // MARK: View Life-Cycle Methods

        override func viewDidLoad() {
            super.viewDidLoad()
            setUpUI()
        }


    // MARK: IBActions

    @IBAction func openWebSite(_ sender: UIButton) {
        if let restaurantURL = restaurantDetail?.urls.pc {
            guard let url = URL(string: restaurantURL) else {return}
            UIApplication.shared.open(url)
        }
    }


    // MARK: Private Methods

    private func setUpUI() {
        if let data = restaurantDetail {
            shopNameLabel.text = data.name
            addressLabel.text = data.address
            catchLabel.text = data.genre.genreCatch
            subCatchLabel.text = data.shopCatch
            genreLabel.text = data.genre.name
            openLabel.text = data.open
            ShowImage.showImage(imageUrl: data.photo.mobile.l, imageView: shopImage)
        }
    }
}
