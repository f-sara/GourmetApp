//
//  ShowImage.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/16.
//

import UIKit

// MARK: - ShowImage

final class ShowImage {


    // MARK: Static Methods

    /// String型の画像URLを変換し、UIImageViewに表示する
    static func showImage(imageUrl: String, imageView: UIImageView, viewController: UIViewController) {
        guard let url = URL(string: imageUrl) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                let title = "画像取得エラー"
                ShowAlert.showAlert(title: title, massage: error.localizedDescription, viewController: viewController)
                return
            }

            if let data = data,
               let image = UIImage(data: data){
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                let error = DataError.imageError
                ShowAlert.showAlert(title: error.errorTitle, massage: error.errorMessage, viewController: viewController)
            }
        }.resume()
    }
}
