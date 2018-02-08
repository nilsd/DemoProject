//
//  ImageFetcher.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit
import Alamofire

protocol ImageFetcherDelegate: class {
    func didCompleteOneImageFetch(url: URL, image: UIImage?)
}

class ImageFetcher {
    
    var isFetching = false
    var currentRequest: DataRequest?
    
    var urlsToFetch = [URL]()
    
    weak var delegate: ImageFetcherDelegate?
    
    
    // MARK: - Private functions
    
    private func fetchOne(url: URL) {
        currentRequest = DataRequest()
        
        currentRequest?.getData(fromURL: url, completion: { [weak self] (data) in
            guard let strongSelf = self else { return }
            
            // 1. Remove fetched url from array
            
            if let index = strongSelf.urlsToFetch.index(where: { u -> Bool in
                return u == url
            }) {
                strongSelf.urlsToFetch.remove(at: index)
            }
            
            
            // 2. Start next fetch if any items left
            
            if let nextURL = strongSelf.urlsToFetch.first {
                strongSelf.fetchOne(url: nextURL)
            } else {
                strongSelf.isFetching = false
            }
            
            
            // 3. Try to create UIImage from data
            
            guard let data = data else {
                strongSelf.delegate?.didCompleteOneImageFetch(url: url, image: nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                strongSelf.delegate?.didCompleteOneImageFetch(url: url, image: nil)
                return
            }
            
            
            // 4. Call delegate function
            
            strongSelf.delegate?.didCompleteOneImageFetch(url: url, image: image)
        })
    }
    
    private func startFetching() {
        guard let url = urlsToFetch.first else { return }
        
        isFetching = true
        fetchOne(url: url)
    }
    
    
    // MARK: - Public functions
    
    func addURLToQueue(url: URL) {
        guard !urlsToFetch.contains(url) else { return }
        
        urlsToFetch.append(url)
        
        if !isFetching {
            startFetching()
        }
    }
    
    
    func cancel() {
        currentRequest?.cancel()
        isFetching = false
    }
    
}
