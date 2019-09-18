//
//  AppsSearchController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/14/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK:- Properties
    
    fileprivate let cellId = "SearchControllerCell"
    fileprivate var appResults = [Result]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchItunesApps()
    
    }
    
    // MARK:- Initialization
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK:- Actions
    
    fileprivate func fetchItunesApps() {
        
        APIService.shared.fetchApps { (results, err) in
            
            if let err = err {
                print("Failed to fetch apps:", err)
                return
            }
            // actually get back our search results somehow
            //print("Finished fetching app from controller")
            
            // we need to get back our search results somehow
            // use a completion block
            
            self.appResults = results
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        
            
            
        }
        
//        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
//
//        guard let url = URL(string: urlString) else { return }
//
//        // fetch data from internet
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if let err = error {
//                print("Failed to fetch Apps:", err)
//                return
//            }
//
//            // success
//
////            print(data)
////            print(String(data: data!, encoding: .utf8))
//
//            guard let data = data else { return }
//
//            do {
//                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
//
//                //print(searchResult)
//                // simple way of checking json in console
//                //searchResult.results.forEach({ print($0.trackName, $0.primaryGenreName) })
//
//                self.appResults = searchResult.results
//
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//
//                }
//
//            } catch let jsonError {
//                print("There is an error decoding JSON: ", jsonError)
//            }
//
//
//        }.resume() // fires off request
        
    }
    
    
    
    // MARK:- Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        
        // use indexPath.item when inside a collectionView / use indexPath.row when using a tableView
        let appResult = appResults[indexPath.item]
        
        cell.nameLabel.text = appResult.trackName
        cell.categoryLabel.text = appResult.primaryGenreName
        cell.ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"
        
        
        
        return cell
    }
    
}
