//
//  Reviews.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 10/14/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import Foundation

struct Reviews: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let author: Author
    let title: Label
    let content: Label
}

struct Author: Decodable {
    let name: Label
}

struct Label: Decodable {
    let label: String
}
