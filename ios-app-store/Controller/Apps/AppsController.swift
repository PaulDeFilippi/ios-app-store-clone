//
//  AppsController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/20/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "AppsControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .yellow
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }

}
