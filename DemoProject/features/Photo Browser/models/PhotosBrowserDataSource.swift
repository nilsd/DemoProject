//
//  PhotosBrowserDataSource.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit

class PhotosBrowserDataSource: NSObject, UICollectionViewDataSource {
    
    // Keeping reference to collection view to be able to perform data updates in this class directly
    weak var collectionView: UICollectionView?
    
    
    /**
     This init will set collection view delegate and register nibs needed. Keeping weak reference to collection view to avoid trouble.
     */
    init(collectionView: UICollectionView) {
        super.init()

        self.collectionView = collectionView
        self.collectionView?.registerNib(named: PhotoCollectionViewCell.cellIdentifier)
        
        self.collectionView?.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellIdentifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
}

extension PhotosBrowserDataSource {
    
    func fetchPhotos() {
        let request = FlickrRequest()
        
        request.fetchPhotos(withTag: "spacex") { (error, flickrResponse) in
            debugPrint(flickrResponse as Any)
        }
    }
    
}
