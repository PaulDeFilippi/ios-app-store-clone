//
//  AppsHeaderCell.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/22/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    // MARK:- Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .green
        
        companyLabel.textColor = .blue
        //imageView.backgroundColor = .red
        titleLabel.numberOfLines = 2
        
        let stackView = VerticalStackView(arrangedSubviews: [
            companyLabel,
            titleLabel,
            imageView
            ], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Views
    
    let companyLabel = UILabel(text: "Facebook",
        font: .boldSystemFont(ofSize: 12))
    
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever",
        font: .systemFont(ofSize: 24))
    
    let imageView = UIImageView(cornerRadius: 8)
}
