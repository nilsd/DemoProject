//
//  FlickrRequest.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import Alamofire

class FlickrRequest {
    
    private let baseURLString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    private var request: Alamofire.Request?
    
    
    func fetchPhotos(withTag tag: String, completion: @escaping FlickrRequestCompletion) {
        let url = baseURLString + "&tags=\(tag)"
        
        request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData(completionHandler: { (response) in
            guard response.error == nil else {
                return completion(.unhandled, nil)
            }
            
            guard let data = response.data else {
                return completion(.noData, nil)
            }
            
            completion(nil, try? CustomDecoder.decode(type: FlickrResponse.self, data: data))
        })
    }
    
}

enum FlickrRequestError: Error {
    case noData
    case unhandled
}

typealias FlickrRequestCompletion = (_ error: FlickrRequestError?, _ flickrResponse: FlickrResponse?) -> ()

