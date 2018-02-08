//
//  ImageCache.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit

class ImageCache {
    struct CachedImage {
        var dateCached: Date
        var url: URL
        var image: UIImage
    }
    
    var imageCountLimit = 100
    private var cached = [CachedImage]()
    
    
    // MARK: - Private functions
    
    private func removeOldestImages() {
        cached.sort { (c1, c2) -> Bool in
            return c1.dateCached < c2.dateCached
        }
        
        cached.removeLast(cached.count - imageCountLimit)
    }
    
    
    // MARK: - Public functions
    
    func getCachedImage(withURL url: URL) -> UIImage? {
        return cached.first(where: { (cachedImage) -> Bool in
            return cachedImage.url == url
        })?.image
    }
    
    func setCachedImage(withURL url: URL, image: UIImage) {
        let cachedImage = CachedImage(dateCached: Date(), url: url, image: image)
        
        if let index = cached.index(where: { (c) -> Bool in
            return c.url == url
        }) {
            cached[index] = cachedImage
        } else {
            cached.append(cachedImage)
        }
        
        
        // Remove oldest images if limit was exceeded
        
        if cached.count > imageCountLimit {
            removeOldestImages()
        }
    }
    
    
    static let shared = ImageCache()
}
