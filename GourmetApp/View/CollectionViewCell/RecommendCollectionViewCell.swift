//
//  RecommendCollectionViewCell.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/05.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nearStationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        backgroundColor = .white
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }

    func setUp(restaurantData: Shop) {
        nameLabel.text = restaurantData.name
        nearStationLabel.text = restaurantData.stationName
        genreLabel.text = restaurantData.genre.name
        showImage(imageUrl: restaurantData.photo.mobile.l)
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
