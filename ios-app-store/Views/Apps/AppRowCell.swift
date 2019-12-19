//
//  AppRowCell.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/21/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppRowCell: UICollectionViewCell {
    
    // MARK:- Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = .purple
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.layer.cornerRadius = 32 / 2
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        let vStack = UIStackView(arrangedSubviews: [nameLabel, companyLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView, vStack, getButton
            ])
        
        addSubview(stackView)
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Views
    
    let imageView = UIImageView(cornerRadius: 8)
    
    let nameLabel = UILabel(text: "App Name",
                            font: .systemFont(ofSize: 20))
    
    let companyLabel = UILabel(text: "Company Name",
                               font: .systemFont(ofSize: 13))
    
    let getButton = UIButton(title: "GET")

}

