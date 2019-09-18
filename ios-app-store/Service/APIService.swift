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
    
    func fetchApps(completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching itunes apps from service layer")
        
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"

        guard let url = URL(string: urlString) else { return }

        // fetch data from internet
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let err = error {
                print("Failed to fetch Apps:", err)
                completion([], nil)
                return
            }

            // success

//            print(data)
//            print(String(data: data!, encoding: .utf8))

            guard let data = data else { return }

            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                //print(searchResult)
                
                completion(searchResult.results, nil)

                //print(searchResult)
                // simple way of checking json in console
                //searchResult.results.forEach({ print($0.trackName, $0.primaryGenreName) })


            } catch let jsonError {
                print("There is an error decoding JSON: ", jsonError)
                completion([], jsonError)
            }


        }.resume() // fires off request
        
    }
}
