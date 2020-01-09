//
//  PreviewBL.swift
//  Filters
//
//  Created by Erez Mizrahi on 09/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
import UIKit


struct PreviewImageVCBL {
    var uiImage: UIImage?
    var cIimage: CIImage?
    
    
    
    var callback : (_ filterdImage: CIImage?, _ extent: CGRect?, Bool)->() = { _,_,_ in }
    
    
     func applyFilter(index: Int) {

        
        guard let filter = Filters(rawValue: index),
            let filterdImage = filter.getImage(image: cIimage!),
            let extent = filter.getImage(image: cIimage!)?.extent else {
                return
                
        }
        changeFilter(with: filter, filterdImage: filterdImage, extent: extent)
    }
    
     func changeFilter(with filter: Filters, filterdImage: CIImage, extent: CGRect) {
        
        switch filter {
        case .gloom:
            callback(filterdImage,extent, false)
        case .zoomBlur:
            callback(filterdImage,extent, false)

        case .monochrome:
            callback(filterdImage,extent, true)

        case .dot:
            callback(filterdImage,extent, false)

        case .gabor:
            callback(filterdImage,extent, false)

        }
    }
    
}
