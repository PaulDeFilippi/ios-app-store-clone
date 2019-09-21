//
//  AppsGroupCell.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/20/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppsGroupCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .lightGray
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        addSubview(horizontalController.view)
        //horizontalController.view.backgroundColor = .blue
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // using the UILabel extention convenience init
    let titleLabel = UILabel(text: "App Section",
        font: .boldSystemFont(ofSize: 30))
    
//    let titleLabel: UILabel = {
//        let tl = UILabel()
//        tl.text = "App Section"
//        tl.font = .boldSystemFont(ofSize: 30)
//        return tl
//    }()
    
    let horizontalController = AppsHorizontalController()
}
