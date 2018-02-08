//
//  UICollectionView+nibs.swift
//  DemoProject
//
//  Created by Nils Dunsö on 2018-02-08.
//  Copyright © 2018 Dunso. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /**
     Makes it a little bit easier to register nibs
    */
    func registerNib(named nibName: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
}
