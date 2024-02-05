//
//  ViewController.swift -> HomeViewController
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/03.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
    }


}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as! RecommendCollectionViewCell
        let flowLayout = UICollectionViewFlowLayout()
        let widthSize = (collectionView.bounds.width - 14) / 2
        let heightSize = widthSize * 1.3
        flowLayout.itemSize = CGSize(width: widthSize, height: heightSize) // セルのサイズを設定
        collectionView.collectionViewLayout = flowLayout

        return cell
    }

}

// スタイルの変更
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10 , left: 2 , bottom: 10 , right: 2 )
    }

    // セルの左右
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    // セルの上下
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
