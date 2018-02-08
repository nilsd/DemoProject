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
    
    @IBOutlet weak var infoWrapper: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    // MARK: - Properties
    
    var dataSource: PhotosBrowserDataSource!
    
    var flickrTagsToFetch = ["spacex", "falconheavy", "starman"]
    var currentFlickrTagIndex = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addSubview(refreshControl)
        dataSource = PhotosBrowserDataSource(collectionView: collectionView)
        
        title = "Loading..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchFlickrImages()
    }
    
    
    // MARK: - UI helpers

    func toggleInfoWrapper(show: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.infoWrapper.alpha = show ? 1 : 0
        })
    }
    
    func updateTitle() {
        let fetchedTags = flickrTagsToFetch.prefix(upTo: currentFlickrTagIndex)
        
        var newTitle = "Flickr: " + fetchedTags.reduce(into: "", { (res, tag) in
            res += tag + ", "
        })
        newTitle.removeLast(2)
        
        title = newTitle
    }

    
    // MARK: - Fetching
    
    func fetchFlickrImages(refreshControl: UIRefreshControl? = nil) {
        guard let tagToFetch = flickrTagsToFetch[safe: currentFlickrTagIndex] else { return }
        guard !dataSource.isFetchingData else { return }
        
        activityIndicator.startAnimating()
        
        dataSource.fetchFlickrPhotos(withTag: tagToFetch) { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.stopAnimating()
            refreshControl?.endRefreshing()
            
            guard success else { return }
            
            strongSelf.currentFlickrTagIndex += 1
            
            strongSelf.updateTitle()
            
            // If no more tags
            if strongSelf.flickrTagsToFetch[safe: strongSelf.currentFlickrTagIndex] == nil {
                strongSelf.infoLabel.isHidden = false
            }
        }
    }
    
    
    // MARK: - User actions
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        dataSource.clearAllData()
        currentFlickrTagIndex = 0
        
        fetchFlickrImages(refreshControl: refreshControl)
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
            bottom: infoWrapper.frame.height,
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
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomDistance = scrollView.contentSize.height - scrollView.contentOffset.y - view.frame.height
        
        // If bottom distance is less than info wrapper height divided by two, show info wrapper.
        toggleInfoWrapper(show: bottomDistance < infoWrapper.frame.height / 2)
    }
    
}
