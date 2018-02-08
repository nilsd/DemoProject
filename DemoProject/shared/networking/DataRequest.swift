//
//  DataRequest.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import Alamofire

class DataRequest {
    
    private var request: Alamofire.Request?
    
    
    deinit {
        cancel()
    }
    
    func getImageData(fromURL url: URL, completion: @escaping DataRequestCompletion) {
        request = Alamofire.request(url).responseData(completionHandler: { (response) in
            completion(response.data)
        })
    }
    
    func cancel() {
        request?.cancel()
    }
}

typealias DataRequestCompletion = (_ data: Data?) -> ()
