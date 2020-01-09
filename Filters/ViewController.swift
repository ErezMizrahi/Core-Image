//
//  ViewController.swift
//  Filters
//
//  Created by Erez Mizrahi on 09/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var camera: CameraDetection?

    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera = CameraDetection(cameraView: cameraView, delegate: self)
              
        camera?.startSession()
        
    }
    


    @IBAction func captureImage(_ sender: Any) {
        camera?.takePic()
    }
    
}

extension ViewController: CapturePhotoDelegate {
    func didCapturePhoto(imageData: (uiImage:UIImage, ciImage: CIImage)) {
        DispatchQueue.main.async {
                  let destVC = ImagePreviewFilterController.createVC()
            destVC.uiImage = imageData.uiImage
            destVC.cIimage = imageData.ciImage
            self.navigationController?.modalPresentationStyle = .overCurrentContext
            self.navigationController?.modalTransitionStyle = .crossDissolve
            
            self.navigationController?.pushViewController(destVC, animated: true)
        }
  
    }
    
    
}
