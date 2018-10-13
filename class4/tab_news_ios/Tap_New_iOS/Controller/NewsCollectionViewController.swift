//
//  NewsCollectionViewController.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 1/7/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewsCollectionViewController: UICollectionViewController {
    var newsList = NewsList().newsList
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionCell")
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return newsList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionCell", for: indexPath) as! NewsCollectionViewCell
        
        cell.titlePreview.text = newsList[indexPath.row].title
        
        DispatchQueue.global().async {
            let urlImage = try? Data(contentsOf: URL(string: self.newsList[indexPath.row].imageUrl!)!)
            if let imageData = urlImage {
                DispatchQueue.main.async {
                    cell.preview.image = UIImage(data: imageData)
                }
            }
        }
    
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let originalCell = newsList.remove(at: sourceIndexPath.item)
        newsList.insert(originalCell, at: destinationIndexPath.item)
    }
}
