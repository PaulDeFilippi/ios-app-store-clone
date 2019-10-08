//
//  AppDetailController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 10/4/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var appId: String! {
        didSet {
            print("Here is my appId: ", appId)
            let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
            
            APIService.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, err) in
                print(result?.results.first?.releaseNotes)
            }
        }
    }
    
    let detailCellID = "detailCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellID)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellID, for: indexPath) as! AppDetailCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
}
