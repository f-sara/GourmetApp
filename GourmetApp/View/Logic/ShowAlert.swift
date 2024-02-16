//
//  ShowAlert.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/16.
//

import UIKit

// MARK: - ShowAlert

final class ShowAlert {


    // MARK: Static Methods

    static func showAlert(title: String, massage: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "閉じる", style: .cancel, handler: { (action) -> Void in })
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
}
