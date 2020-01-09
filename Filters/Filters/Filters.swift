//
//  Filters.swift
//  Filters
//
//  Created by Erez Mizrahi on 09/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

enum Filters: Int {
    case gloom
    case zoomBlur
    case monochrome
    case dot
    case gabor
    
    
    func getImage(image: CIImage, color: CIColor = CIColor()) -> CIImage? {
        switch self {
        case .dot:
            return dot(image: image)
        case .gabor:
            return gabor(image: image)
        case .gloom:
            return gloomEffect(image: image)
        case .monochrome:
            return colorMonochrome(color: color, image: image)
        case .zoomBlur:
            return zoomBlur(image: image)
        }
    }
    
    private func gloomEffect(image: CIImage)  -> CIImage {
         let filter = CIFilter.gloom()
         filter.intensity = 0.9
         filter.radius = 0
         filter.inputImage = image
         return filter.outputImage!
     }
     
    private func zoomBlur(image: CIImage) -> CIImage {
         let filter = CIFilter.zoomBlur()
         filter.amount = 0.9
         
         filter.inputImage = image
         return filter.outputImage!
     }
    private func colorMonochrome(color: CIColor = CIColor.white, image: CIImage) -> CIImage {
         let filter = CIFilter.colorMonochrome()
         filter.intensity = 0.4
         filter.color = color
         filter.inputImage = image
         return filter.outputImage!
     }
     private func dot(image: CIImage)  -> CIImage {
         let filter = CIFilter.dotScreen()
         filter.angle = 0.3
         filter.inputImage = image
         return filter.outputImage!
     }
     private func gabor(image: CIImage)  -> CIImage {
         let filter = CIFilter.gaborGradients()
         filter.inputImage = image
         return filter.outputImage!
     }
     
}
