//
//  ColorCell.swift
//  Filters
//
//  Created by Erez Mizrahi on 09/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    static let id: String = "cell"
    
    
    func configure(color: CIColor, image: UIImage) {
        let uicolor = UIColor(ciColor: color)
        
        imageView.image = image

        let tintView = UIView()
        tintView.backgroundColor = uicolor.withAlphaComponent(0.3)
        tintView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        imageView.addSubview(tintView)
        
    }
    
}
