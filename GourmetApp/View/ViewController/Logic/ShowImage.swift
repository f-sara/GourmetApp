//
//  ShowImage.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/16.
//

import Foundation
import UIKit

final class ShowImage {

    static func showImage(imageUrl: String, imageView: UIImageView) {
        guard let url = URL(string: imageUrl) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }

            if let data = data,
               let image = UIImage(data: data){
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                print("画像表示エラー")
            }
        }.resume()
    }
}
