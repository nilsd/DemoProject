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
    
    var flickrItems = [FlickrItem]()
    
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.populate(item: flickrItems[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrItems.count
    }
    
}

extension PhotosBrowserDataSource {
    
    // TODO: Smarter and cleaner fetching
    
    func fetchPhotos() {
        let request = FlickrRequest()
        
        request.fetchPhotos(withTag: "spacex") { (error, flickrResponse) in
            guard let response = flickrResponse else {
                return
            }
            
            self.flickrItems = response.items
            self.collectionView?.reloadData()
        }
    }
    
}
