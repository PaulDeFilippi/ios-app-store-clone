//
//  AppsController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/20/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    // MARK:- Properties
    
    let cellId = "AppsControllerCell"
    let headerId = "headerId"
    var editorsChoiceGames: AppGroup?
    var groups = [AppGroup]()
    
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchData()
    }
    
    fileprivate func fetchData() {
        
        // help you sync data fetches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        APIService.shared.fetchGames { (appGroup, err) in
            
            dispatchGroup.leave()
            
            if let group = appGroup {
                self.groups.append(group)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        dispatchGroup.enter()
        
        APIService.shared.fetchTopGrossing { (appGroup, err) in
            
            dispatchGroup.leave()
            
            if let group = appGroup {
                self.groups.append(group)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        dispatchGroup.enter()
        APIService.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
            dispatchGroup.leave()
            if let group = appGroup {
                self.groups.append(group)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        // completion
        dispatchGroup.notify(queue: .main) {
            print("completed your dispatch group tasks.....")
        }
    }
    
    // MARK:- Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = groups[indexPath.item]
        
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }

}
