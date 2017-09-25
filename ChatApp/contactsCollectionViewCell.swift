//
//  contactsCollectionViewCell.swift
//  ChatApp
//
//  Created by Sai Madhukar on 18/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit

class contactsCollectionViewCell: UICollectionViewCell {
    
    @objc var textLabel = UILabel()
    
    @objc var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        addSubview(textLabel)
        textLabel.alpha = 0.5
        textLabel.text = "loading..."
        textLabel.backgroundColor = .black
        textLabel.textAlignment = .center

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

  
    
    
    
    
    
    
}
