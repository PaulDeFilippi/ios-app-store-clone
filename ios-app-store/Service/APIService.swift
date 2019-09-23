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
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching itunes apps from service layer")
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"

        guard let url = URL(string: urlString) else { return }

        // fetch data from internet
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let err = error {
                print("Failed to fetch Apps:", err)
                completion([], nil)
                return
            }

            // success
            guard let data = data else { return }

            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                completion(searchResult.results, nil)

            } catch let jsonError {
                print("There is an error decoding JSON: ", jsonError)
                completion([], jsonError)
            }
            
        }.resume() // fires off request
    }
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // a few options to make sure you are getting data back in response befrore we start decoding json
            //print(data)
            //print(String(data: data!, encoding: .utf8))
            
            if let err = error {
                print("There was an error: ", err)
                completion(nil, err)
                return
            }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data!)
                //print(appGroup.feed.results)
                appGroup.feed.results.forEach({print($0.name)})
                completion(appGroup, nil)
            } catch {
                completion(nil, error)
                //print("Failed to decode: ", error)
            }
            
            
        }.resume()
        
        
    }
}
