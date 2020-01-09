//
//  Camera.swift
//  Filters
//
//  Created by Erez Mizrahi on 09/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
import AVKit

protocol CapturePhotoDelegate: class {
    func didCapturePhoto(imageData: (uiImage:UIImage, ciImage: CIImage))
}

class CameraDetection: NSObject {
    private let captureSession: AVCaptureSession
    private let cameraView: UIView?
    private let queue = DispatchQueue(label: "videoQueue")
    
    private var takePhoto: Bool = false
    weak var delegate: CapturePhotoDelegate?
    
    init(cameraView: UIView, delegate: CapturePhotoDelegate) {
        self.captureSession = AVCaptureSession()
        self.cameraView = cameraView
        self.delegate = delegate
    }
    
    private func setupDevice() throws {
        
        captureSession.sessionPreset = .photo
        let avalibaleDevices =  AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: .video,
                                                                      position: .front).devices
        guard let captureDevice = avalibaleDevices.first else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        self.captureSession.addInput(input)
        self.captureSession.startRunning()
    }
    
    private func setPreviewLayer(with cameraView: UIView) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        cameraView.layer.addSublayer(previewLayer)
        
        previewLayer.frame = cameraView.frame
        
    }
    
    
    //public api
    func startSession() {
        guard let cameraView = cameraView else { return }
        do {
            try? self.setupDevice()
            
            self.setPreviewLayer(with: cameraView)
            setOutput()
            
        }
    }
    
    
    func setOutput() {
        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.videoSettings = [(kCVPixelBufferPixel as String) : NSNumber(value: kcvpixelformat)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
            captureSession.commitConfiguration()
            
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
    }

    func takePic() {
        self.takePhoto = true
    }
}


extension CameraDetection:AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard takePhoto else { return }
        self.takePhoto.toggle()
        guard let image = getImageBuffer(buffer: sampleBuffer) else { return }
        delegate?.didCapturePhoto(imageData: image)
    }
    
    private func getImageBuffer(buffer: CMSampleBuffer) -> (uiImage:UIImage, ciImage: CIImage)? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let context = CIContext()

        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        
        guard let image = context.createCGImage(ciImage, from: imageRect) else { return nil }
        return (uiImage: UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right),
                ciImage: ciImage)
    }
}
