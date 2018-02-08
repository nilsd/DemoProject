//
//  FlickrResponse.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import Foundation

struct FlickrResponse: Codable {
    var title: String
    var items: [FlickrItem]
}
