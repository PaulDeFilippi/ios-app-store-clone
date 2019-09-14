//
//  AppsSearchController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/14/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppsSearchController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .red
    
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
