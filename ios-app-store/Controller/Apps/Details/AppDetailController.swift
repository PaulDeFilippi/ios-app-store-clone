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
            print("Here is my appId: ", appId ?? "")
            let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
            
            APIService.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, err) in
                
                let app = result?.results.first
                
                self.app = app
                //print(result?.results.first?.releaseNotes)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
            let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=en&cc=us"
            print(reviewsUrl)
            
            APIService.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews: Reviews?, err) in
                if let err = err {
                    print("Failed to decode reviews:", err)
                    return
                }
                
                self.reviews = reviews
                
                //reviews?.feed.entry.forEach({print($0.rating.label)})
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
//                reviews?.feed.entry.forEach({ (entry) in
//                    print("Here is the title: \(entry.title.label)     ", "Here is the Author: \(entry.author.name.label)      ", "Here is the content: \(entry.content.label)       ")
//                })
            }
        }
    }
    
    var app : Result?
    var reviews: Reviews?
    
    let detailCellId = "detailCellId"
    let previewCellId = "previewCellId"
    let reviewCellId = "reviewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
            cell.app = app
            
            return cell
            
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.horizontalController.app = self.app
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewRowCell
            cell.reviewsController.reviews = self.reviews
            
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 280
        
        if indexPath.item == 0 {
            
            // calculate the necessary size for cell somehow
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            
            //        dummyCell.nameLabel.text = app?.trackName
            //        dummyCell.releaseNotesLabel.text = app?.releaseNotes
            //        dummyCell.appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            //        dummyCell.priceButton.setTitle(app?.formattedPrice, for: .normal)
            
            dummyCell.app = app
            
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            
            height = estimatedSize.height
            
            //return .init(width: view.frame.width, height: estimatedSize.height)
            
        } else if indexPath.item == 1 {
            //return .init(width: view.frame.width, height: 500)
            height = 500
        } else {
            //return .init(width: view.frame.width, height: 280)
            height = 280
        }
        
        return .init(width: view.frame.width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
