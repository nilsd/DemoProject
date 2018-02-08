//
//  PhotoCollectionViewCell.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit
import Alamofire

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "PhotoCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func populateImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
}
