//
//  SearchViewController.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/13.
//

import UIKit

// MARK: - SearchViewController

class SearchViewController: UIViewController {


    // MARK: Private Properties

    private let genre: [String] = ["G004", "G005", "G007", "G013", "G014", "G001"]


    // MARK: IBOutlets

    @IBOutlet @ViewLoading var collectionView: UICollectionView


    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCell")
    }


    // MARK: Other Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResult" {
            let searchResultViewController = segue.destination as! SearchResultViewController
            searchResultViewController.genre = sender as? String
        }
    }
}


// MARK: - Extensions UICollectionViewDataSource, UICollectionViewDelegate

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCollectionViewCell
        cell.setup(index: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showSearchResult", sender: genre[indexPath.item])
    }
}


// MARK: - Extensions UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.bounds.width - 80) / 2
        let heightSize = (collectionView.bounds.height - 80) / 3
        return CGSize(width: widthSize, height: heightSize)
    }
}
