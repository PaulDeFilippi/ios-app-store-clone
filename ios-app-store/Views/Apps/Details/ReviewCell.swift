//
//  ReviewCell.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 10/13/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    // MARK:- Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel, authorLabel
                ], customSpacing: 8),
            starsStackView,
            bodyLabel,
            UIView()
            ], spacing: 12)
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Views
    
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let starsStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach({ (_) in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangedSubviews.append(imageView)
        })
        
        arrangedSubviews.append(UIView())
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        return stackView
    }()
    
    let bodyLabel = UILabel(text: "Review body\nReview body\nReview body\n", font: .systemFont(ofSize: 18), numberOfLines: 0)
    
}
