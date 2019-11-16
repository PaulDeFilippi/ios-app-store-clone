//
//  TodayItem.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 11/6/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    let cellType: CellType
    
    enum CellType: String {
        case single
        case multiple
    }
}
