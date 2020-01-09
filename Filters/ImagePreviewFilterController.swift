//
//  ImagePreviewFilterController.swift
//  Filters
//
//  Created by Erez Mizrahi on 09/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImagePreviewFilterController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var container: UIView!
    
    var uiImage: UIImage?
    var cIimage: CIImage?
    
    var srcScale : CGFloat? // <-- keep this value
    var srcOrientation: UIImage.Orientation? // <-- keep that value
    
    @objc var showColorPalet: Bool = false {
        didSet {
            container.isHidden = !showColorPalet
        }
    }
    
    var childVC: CollectionViewController? {
        return children.compactMap{ $0 as? CollectionViewController}.first
    }
    
    
    class func createVC() -> ImagePreviewFilterController {
        return UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ImagePreviewFilterController") as! ImagePreviewFilterController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = uiImage else {
            return
        }
        childVC?.colorDelegate = self
        childVC?.image = image
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.imageView.image = uiImage
        
        srcScale = imageView.image?.scale ?? 0.0
        srcOrientation = imageView.image?.imageOrientation ?? UIImage.Orientation.right
        print(imageView.frame)
        
    }
    
    
    @IBAction func didSelectFilter(_ sender: UISegmentedControl) {
        applyFilter(index: sender.selectedSegmentIndex)
    }
    
    private func applyFilter(index: Int) {
        let context = CIContext()
        showColorPalet = false
        switch index {
        case 0:
            let image = context.createCGImage(gloomEffect(), from: gloomEffect().extent)
            imageView.contentMode = .scaleAspectFit
            self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
        case 1:
            let image = context.createCGImage(zoomBlur(), from: zoomBlur().extent)
            imageView.contentMode = .scaleAspectFit
            self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
        case 2:
            showColorPalet = true
            
            let image = context.createCGImage(crystalize(), from: crystalize().extent)
            imageView.contentMode = .scaleAspectFit
            self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
        case 3:
            let image = context.createCGImage(dot(), from: dot().extent)
            imageView.contentMode = .scaleAspectFit
            self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
        case 4:
            let image = context.createCGImage(gabor(), from: gabor().extent)
            imageView.contentMode = .scaleAspectFit
            self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
        default:
            break
        }
    }
    
    private func gloomEffect() -> CIImage {
        let filter = CIFilter.gloom()
        filter.intensity = 0.9
        filter.radius = 0
        filter.inputImage = cIimage
        return filter.outputImage!
    }
    
    private func zoomBlur() -> CIImage {
        guard let image = self.cIimage else { return CIImage()}
        let filter = CIFilter.zoomBlur()
        filter.amount = 0.9
        
        filter.inputImage = image
        return filter.outputImage!
    }
    private func crystalize(color: CIColor = CIColor.white) -> CIImage {
        let filter = CIFilter.colorMonochrome()
        filter.intensity = 0.4
        filter.color = color
        filter.inputImage = cIimage
        return filter.outputImage!
    }
    private func dot() -> CIImage {
        let filter = CIFilter.dotScreen()
        filter.angle = 0.3
        filter.inputImage = cIimage
        return filter.outputImage!
    }
    private func gabor() -> CIImage {
        let filter = CIFilter.gaborGradients()
        filter.inputImage = cIimage
        return filter.outputImage!
    }
    
    
    
}

extension ImagePreviewFilterController: ColorSelectionDelegate {
    func didSelectColor(color: CIColor) {
        let context = CIContext()
        
        let image = context.createCGImage(crystalize(color: color), from: crystalize().extent)
        imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
    }
}
