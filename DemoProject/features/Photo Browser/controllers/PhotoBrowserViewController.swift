//
//  PhotoBrowserViewController.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let request = FlickrRequest()
        
        request.fetchPhotos(withTag: "spacex") { (error, flickrResponse) in
            debugPrint(flickrResponse as Any)
        }
    }
    
}
