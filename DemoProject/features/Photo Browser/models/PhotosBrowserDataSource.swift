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
    
    var media = [RemoteMedia]()
    var flickrRequest: FlickrRequest?
    var imageFetcher = ImageFetcher()
    
    
    /**
     This init will set collection view delegate and register all nibs needed.
     */
    init(collectionView: UICollectionView) {
        super.init()

        // Setup collection view
        
        self.collectionView = collectionView
        self.collectionView?.registerNib(named: PhotoCollectionViewCell.cellIdentifier)
        
        self.collectionView?.dataSource = self
        
        
        // Setup image fetcher
        
        imageFetcher.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let mediaItem = media[indexPath.item]
        
        if let image = ImageCache.shared.getCachedImage(withURL: mediaItem.url) {
            cell.populateImage(image)
        } else {
            imageFetcher.addURLToQueue(url: mediaItem.url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
}


// MARK: - Fetching

extension PhotosBrowserDataSource {
    
    func fetchFlickrPhotos(withTag tag: String) {
        flickrRequest = FlickrRequest()
        
        flickrRequest?.fetchPhotos(withTag: tag, completion: { (error, response) in
            guard error == nil else {
                debugPrint(error! as Any)
                return
            }
            
            guard let flickrItems = response?.items else {
                debugPrint("No Flickr items fetched")
                return
            }
            
            self.media = flickrItems.map { item in
                return FlickrMedia(url: item.media.url)
            }
            
            self.collectionView?.reloadData()
        })
    }
    
    
    func stopFetching() {
        flickrRequest?.cancel()
        imageFetcher.cancel()
    }
    
}


// MARK: - ImageFetcherDelegate

extension PhotosBrowserDataSource: ImageFetcherDelegate {
    
    func didCompleteOneImageFetch(url: URL, image: UIImage?) {
        guard let image = image else { return }
        
        // Store image in ImageCache
        
        ImageCache.shared.setCachedImage(withURL: url, image: image)
        
        
        // Reload cells

        var indexPaths = [IndexPath]()
        
        for (index, mediaItem) in media.enumerated() {
            guard mediaItem.url == url else { continue }
            indexPaths.append(IndexPath(item: index, section: 0))
        }
        
        collectionView?.reloadItems(at: indexPaths)
    }
    
}
