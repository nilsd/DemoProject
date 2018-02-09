//
//  FlickrRequest.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import Alamofire

/**
 Fetches items from Flickr public feed API
 */
class FlickrRequest {
    
    private let baseURLString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    private var request: Alamofire.Request?
    
    var isFetching = false
    
    
    func fetchPhotos(withTag tag: String, completion: @escaping FlickrRequestCompletion) {
        let url = baseURLString + "&tags=\(tag)"
        
        isFetching = true
        
        request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData(completionHandler: { [weak self] (response) in
            self?.isFetching = false
            
            guard response.error == nil else {
                return completion(.unhandled, nil)
            }
            
            guard let data = response.data else {
                return completion(.noData, nil)
            }
            
            completion(nil, try? JSONDecoder().decode(FlickrResponse.self, from: data))
        })
    }
    
    func cancel() {
        request?.cancel()
        isFetching = false
    }
    
}

enum FlickrRequestError: Error {
    case noData
    case unhandled
}

typealias FlickrRequestCompletion = (_ error: FlickrRequestError?, _ flickrResponse: FlickrResponse?) -> ()

