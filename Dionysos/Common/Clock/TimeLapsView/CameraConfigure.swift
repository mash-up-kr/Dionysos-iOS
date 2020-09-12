//
//  CameraConfigure.swift
//  Dionysos
//
//  Created by Jercy on 2020/08/30.
//  Copyright © 2020 Mashup. All rights reserved.
//

import AVFoundation
import UIKit

class CameraConfiguration: NSObject {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    enum CameraPosition {
        case front
        case rear
    }
    
    enum OutputType {
        case video
    }
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var audioDevice: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var flashMode: AVCaptureDevice.FlashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var videoRecordCompletionBlock: ((URL?, Error?) -> Void)?
    
    var videoOutput: AVCaptureMovieFileOutput?
    var audioInput: AVCaptureDeviceInput?
    var outputType: OutputType?
}

extension CameraConfiguration {
    func setup(handler: @escaping (Error?) -> Void ) {
        func configureCaptureDevices() throws {
            let session: AVCaptureDevice.DiscoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            
            let cameras: ([AVCaptureDevice]) = (session.devices.compactMap { $0 })
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
            self.audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        }
        
        func configureDeviceInputs() throws {
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                    self.currentCameraPosition = .rear
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            } else if let frontCamera: AVCaptureDevice = frontCamera {
                frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                if captureSession.canAddInput(frontCameraInput!) {
                    captureSession.addInput(frontCameraInput!)
                    currentCameraPosition = .front
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            if let audioDevice: AVCaptureDevice = audioDevice {
                audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if captureSession.canAddInput(audioInput!) {
                    captureSession.addInput(audioInput!)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            }
        }
        
        func configureVideoOutput() throws {
            self.videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(self.videoOutput!) {
                captureSession.addOutput(self.videoOutput!)
            }
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "setup").async {
            do {
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configureVideoOutput()
            } catch {
                DispatchQueue.main.async {
                    handler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                handler(nil)
            }
        }
    }
    
    func displayPreview(_ view: UIView) throws {
        guard captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        captureSession.beginConfiguration()
        let inputs: [AVCaptureInput] = captureSession.inputs
        
        func switchToFrontCamera() throws {
            guard let rearCameraInput = rearCameraInput, inputs.contains(rearCameraInput), let frontCamera = frontCamera else { throw CameraControllerError.invalidOperation }
            captureSession.removeInput(rearCameraInput)
            frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(frontCameraInput!) {
                captureSession.addInput(frontCameraInput!)
                self.currentCameraPosition = .front
            } else { throw CameraControllerError.invalidOperation }
        }
        
        func switchToRearCamera() throws {
            guard let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput), let rearCamera = rearCamera else { throw CameraControllerError.invalidOperation }
            captureSession.removeInput(frontCameraInput)
            rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            if captureSession.canAddInput(rearCameraInput!) {
                captureSession.addInput(rearCameraInput!)
                self.currentCameraPosition = .rear
            } else { throw CameraControllerError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        captureSession.commitConfiguration()
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        let settings: AVCapturePhotoSettings = AVCapturePhotoSettings()
        settings.flashMode = flashMode
        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletionBlock = completion
    }
    
    func recordVideo(completion: @escaping (URL?, Error?) -> Void) {
        guard captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let paths: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl: URL = paths[0].appendingPathComponent("output.mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput!.startRecording(to: fileUrl, recordingDelegate: self)
        videoRecordCompletionBlock = completion
    }
    
    func stopRecording(completion: @escaping (Error?) -> Void) {
        guard captureSession.isRunning else {
            completion(CameraControllerError.captureSessionIsMissing)
            return
        }
        videoOutput?.stopRecording()
    }
}

extension CameraConfiguration: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error: Error = error { photoCaptureCompletionBlock?(nil, error) }
        if let data: Data = photo.fileDataRepresentation() {
            let image: UIImage? = UIImage(data: data)
            photoCaptureCompletionBlock?(image, nil)
        } else {
            photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
    
    func convert(cmage: CIImage) -> UIImage {
        let context: CIContext = CIContext.init(options: nil)
        let cgImage: CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image: UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}

extension CameraConfiguration: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            videoRecordCompletionBlock?(outputFileURL, nil)
        } else {
            videoRecordCompletionBlock?(nil, error)
        }
    }
}

extension CameraConfiguration: AVCaptureVideoDataOutputSampleBufferDelegate {
}
