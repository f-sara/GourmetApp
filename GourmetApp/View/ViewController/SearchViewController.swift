//
//  SearchViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/13.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet @ViewLoading var collectionView: UICollectionView

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCell")
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCollectionViewCell
        cell.setup(index: indexPath.item)
        return cell
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.bounds.width - 80) / 2
        let heightSize = widthSize * 1.1
        return CGSize(width: widthSize, height: heightSize)
    }
}
