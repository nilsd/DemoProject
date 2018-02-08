//
//  PhotoBrowserViewController.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: PhotosBrowserDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = PhotosBrowserDataSource(collectionView: collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataSource.fetchPhotos()
    }
    
}
