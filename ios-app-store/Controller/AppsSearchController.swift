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
    
    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Result]
    }
    
    struct Result: Decodable {
        let trackName: String
        let primaryGenreName: String
    }
    
    // MARK:- Actions
    
    fileprivate func fetchItunesApps() {
        
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        
        guard let url = URL(string: urlString) else { return }
        
        // fetch data from internet
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("Failed to fetch Apps:", err)
                return
            }
            
            // success
            
//            print(data)
//            print(String(data: data!, encoding: .utf8))
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                //print(searchResult)
                // simple way of checking json in console
                searchResult.results.forEach({ print($0.trackName, $0.primaryGenreName) })
                
            } catch let jsonError {
                print("There is an error decoding JSON: ", jsonError)
            }
            
            
        }.resume() // fires off request
        
    }
    
    
    
    // MARK:- Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.nameLabel.text = "HERE IS MY APP NAME"
        
        
        return cell
    }
    
}
