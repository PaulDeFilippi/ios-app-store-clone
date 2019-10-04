//
//  APIService.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/16/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import Foundation

class APIService {
    
    static let shared = APIService() // Singlton
    
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        print("Fetching itunes apps from service layer")
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
        

//        guard let url = URL(string: urlString) else { return }
//
//        // fetch data from internet
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if let err = error {
//                print("Failed to fetch Apps:", err)
//                completion([], nil)
//                return
//            }
//
//            // success
//            guard let data = data else { return }
//
//            do {
//                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
//                
//                completion(searchResult.results, nil)
//
//            } catch let jsonError {
//                print("There is an error decoding JSON: ", jsonError)
//                completion([], jsonError)
//            }
//            
//        }.resume() // fires off request
    }
    
    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
        
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
        
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    // helper function
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    // generic json function
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        
        print("T is of type: ", T.self)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                // success
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
            
            }.resume()
        
    }
}
