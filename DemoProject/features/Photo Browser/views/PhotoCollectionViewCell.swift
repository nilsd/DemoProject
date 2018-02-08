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
    
    var imageRequest: DataRequest?
    
    
    func populate(item: FlickrItem) {
        fetchImage(withURL: item.media.url)
    }
    
    
    override func prepareForReuse() {
        imageRequest?.cancel()
        imageView.image = nil
    }
    
}

// TODO: Move image requests to a more appropriate place

extension PhotoCollectionViewCell {
    
    private func fetchImage(withURL url: URL) {
        imageRequest?.cancel()
        
        imageRequest = DataRequest()
        imageRequest?.getImageData(fromURL: url, completion: { (data) in
            guard let data = data else {
                debugPrint("Could not fetch image data", url.absoluteString)
                return
            }
            
            guard let image = UIImage(data: data) else {
                debugPrint("Could not decode image from data", url.absoluteString)
                return
            }
            
            self.imageView.image = image
        })
    }
    
}

