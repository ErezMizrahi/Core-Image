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
    
    var bl : PreviewImageVCBL!
    
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
        bl = PreviewImageVCBL(uiImage: uiImage, cIimage: cIimage)
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
        
        bl.callback = {[weak self] (filteredImage, extent, showColorPalet) in
            guard let self = self else { return }
            guard let image = filteredImage,
                let extent = extent else {
                    return
                    
            }
            self.showColorPalet = showColorPalet
            self.applyImageChanges(filterdImage: image, extent: extent)
        }
        
    }
    
    
    @IBAction func didSelectFilter(_ sender: UISegmentedControl) {
        bl.applyFilter(index: sender.selectedSegmentIndex)
    }
    
    private func applyImageChanges(filterdImage: CIImage, extent: CGRect) {
        let context = CIContext()
        
        let image = context.createCGImage(filterdImage, from: extent)
        imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage(cgImage: image! ,scale: srcScale!, orientation: srcOrientation!)
    }
}

extension ImagePreviewFilterController: ColorSelectionDelegate {
    func didSelectColor(color: CIColor) {
        let filterdImage = Filters.monochrome.getImage(image: cIimage!, color: color)!
        let extent = Filters.monochrome.getImage(image: cIimage!, color: color)!.extent
        
        bl.changeFilter(with: .monochrome, filterdImage: filterdImage, extent: extent)
    }
}
