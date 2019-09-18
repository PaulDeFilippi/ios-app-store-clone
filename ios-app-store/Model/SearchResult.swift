//
//  SearchResult.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/16/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
}
