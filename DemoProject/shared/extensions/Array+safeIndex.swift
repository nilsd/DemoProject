//
//  Array+safeIndex.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
