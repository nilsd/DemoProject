//
//  PhotoBrowserViewController.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    
    var dataSource: PhotosBrowserDataSource!
    
    var flickrTagsToFetch = ["spacex", "falconheavy", "starman"]
    var currentFlickrTagIndex = 0
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = PhotosBrowserDataSource(collectionView: collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchFlickrImages()
    }
    
    
    func fetchFlickrImages() {
        guard let tagToFetch = flickrTagsToFetch[safe: currentFlickrTagIndex] else { return }
        guard !dataSource.isFetchingData else { return }
        
        dataSource.fetchFlickrPhotos(withTag: tagToFetch) { [weak self] success in
            guard success else { return }
            self?.currentFlickrTagIndex += 1
        }
    }
    
}


// MARK: - Collection view layout

extension PhotoBrowserViewController : UICollectionViewDelegateFlowLayout {
    
    // MARK: UI properties
    
    private var defaultSpacing: CGFloat {
        return 10
    }
    
    private var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: defaultSpacing,
            left: defaultSpacing,
            bottom: defaultSpacing,
            right: defaultSpacing
        )
    }
    
    private var itemsPerRow: CGFloat {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            return 2
        default:
            return 3
        }
    }
    
    
    // MARK: Layout delegate functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    // MARK: Delegate functions
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If displaying last cell, try to fetch more photos
        if dataSource.isLastIndexPath(indexPath) {
            fetchFlickrImages()
        }
    }
    
}
