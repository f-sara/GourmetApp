//
//  GenreCollectionViewCell.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/14.
//

import UIKit

// MARK: - GenreCollectionViewCell

class GenreCollectionViewCell: UICollectionViewCell {


    // MARK: Private Properties

    private let genreImages = [
        UIImage(named: "japaneseFood"),
        UIImage(named: "westernFood"),
        UIImage(named: "chineseFood"),
        UIImage(named: "ramen"),
        UIImage(named: "cafe"),
        UIImage(named: "izakaya")
    ]
    private let genreName =  ["和食", "洋食", "中華", "ラーメン", "カフェ", "居酒屋"]


    // MARK: IBOutlets

    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!


    // MARK: View Life-Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpShadow()
    }


    // MARK: Internal Methods

    func setup(index: Int) {
        genreImage.image = genreImages[index]
        genreLabel.text = genreName[index]
    }


    // MARK: Private Methods

    private func setUpShadow() {
        clipsToBounds = false
        backgroundColor = .white
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
}
