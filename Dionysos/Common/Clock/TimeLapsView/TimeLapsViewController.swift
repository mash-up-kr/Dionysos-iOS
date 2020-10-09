//
//  TimeLapsViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/08/30.
//  Copyright © 2020 Mashup. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

final class TimeLapsViewController: UIViewController {
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var previewImageView: UIView!
    @IBOutlet private weak var toggleCameraButton: UIButton!
    @IBOutlet private weak var encodingView: UIView!
    
    var cameraConfig: CameraConfiguration!
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    
    var videoRecordingStarted: Bool = false {
        didSet {
            if videoRecordingStarted {
                cameraButton.setImage(UIImage(named: "btnStop88Px"), for: .normal)
            } else {
                cameraButton.setImage(UIImage(named: "btnPlay88Px"), for: .normal)
            }
        }
    }
    
    fileprivate func registerNotification() {
        let notificationCenter: NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name(rawValue: "App is going background"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc
    func appMovedToBackground() {
        if videoRecordingStarted {
            videoRecordingStarted = false
            cameraConfig.stopRecording { error in
                print(error ?? "Video recording error")
            }
        }
    }
    
    @objc
    func appCameToForeground() {
        print("app enters foreground")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        encodingView.isHidden = true
        self.cameraConfig = CameraConfiguration()
        cameraConfig.setup { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            try? self.cameraConfig.displayPreview(self.previewImageView)
        }
        registerNotification()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc
    fileprivate func showToastForSaved() {
        //            showToast(message: "Saved!", fontSize: 12.0)
    }
    
    @objc
    fileprivate func showToastForRecordingStopped() {
        //            showToast(message: "Recording Stopped", fontSize: 12.0)
    }
    
    @objc
    func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
//            showToast(message: "Could not save!! \n\(error)", fontSize: 12)
        } else {
//            showToast(message: "Saved", fontSize: 12.0)
        }
    }
    
    @IBAction private func didTapOnTakePhotoButton(_ sender: Any) {
        if videoRecordingStarted {
            videoRecordingStarted = false
            cameraConfig.stopRecording { error in
                print(error ?? "Video recording error")
            }
        } else if !videoRecordingStarted {
            //TODO: 시간 시작
            videoRecordingStarted = true
            cameraConfig.recordVideo { [weak self] url, error in
                guard let url = url else {
                    print(error ?? "Video recording error")
                    return
                }
                //TODO: 시간 멈추기
                self?.timeLapse(url)
            }
        }
    }

    @IBAction private func toggleCamera(_ sender: Any) {
        do {
            try cameraConfig.switchCameras()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction private func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func timeLapse(_ url: URL) {
        let videoAsset: AVAsset = AVURLAsset(url: url, options: nil)
        let mixComposition: AVMutableComposition = AVMutableComposition()

        let videoTrack: AVMutableCompositionTrack? = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let videoScaleFactor: Int64 = 5
        let duration: CMTime = CMTimeMake(value: videoAsset.duration.value / videoScaleFactor, timescale: videoAsset.duration.timescale)
        do {
            if let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: .video).first {
                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: CMTime.zero)
            }
        } catch let error as NSError {
            print("error: \(error)")
        }

        
        let mainInstruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration)

        let videoLayerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
        let videoAssetTrack: AVAssetTrack? = videoAsset.tracks(withMediaType: .video).first
        var assetOrientation: UIImage.Orientation = .up
        var isPortrait: Bool = false
        let transform: CGAffineTransform = videoAssetTrack!.preferredTransform
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }

        videoLayerInstruction.setTransform(videoAssetTrack!.preferredTransform, at: CMTime.zero)
        videoLayerInstruction.setOpacity(0.0, at: videoAsset.duration)

        mainInstruction.layerInstructions = [videoLayerInstruction]

        let mainComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMakeWithSeconds(1.0 / 5.0, preferredTimescale: 90_000)
        var naturalSize: CGSize
        if isPortrait {
            naturalSize = CGSize(width: videoAssetTrack!.naturalSize.height, height: videoAssetTrack!.naturalSize.width)
        } else {
            naturalSize = videoAssetTrack!.naturalSize
        }

        mainComposition.renderSize = CGSize(width: naturalSize.width, height: naturalSize.height)

        let tempName = "temp-thread.mov"
        let tempURL = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent(tempName))
        do {
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(at: tempURL)
            }
        } catch {
            print("Error removing temp file.")
        }
        // create final video using export session
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = tempURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = mainComposition
        encodingView.isHidden = false
        print("Exporting video...")
        exportSession.exportAsynchronously {
            DispatchQueue.main.async { [weak self] in
                switch exportSession.status {
                // Success
                case .completed:
                    self?.saveVideo(exportSession.outputURL!)
                case .cancelled, .exporting, .failed, .unknown, .waiting:
                    print("Export status: \(exportSession.status.rawValue)")
                    print("Reason: \(String(describing: exportSession.error))")
                }
            }
        }
    }
    func saveVideo(_ url: URL) {
        let videoAsset: AVAsset = AVURLAsset(url: url, options: nil)
        let mixComposition: AVMutableComposition = AVMutableComposition()

        let videoTrack: AVMutableCompositionTrack? = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let videoScaleFactor: Int64 = 5
        let duration: CMTime = CMTimeMake(value: videoAsset.duration.value / videoScaleFactor, timescale: videoAsset.duration.timescale)
        do {
            if let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: .video).first {
                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: CMTime.zero)
                videoTrack?.scaleTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), toDuration: duration)
            }
        } catch let error as NSError {
            print("error: \(error)")
        }

        
        let mainInstruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)

        let videoLayerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
        let videoAssetTrack: AVAssetTrack? = videoAsset.tracks(withMediaType: .video).first
        var assetOrientation: UIImage.Orientation = .up
        var isPortrait: Bool = false
        let transform: CGAffineTransform = videoAssetTrack!.preferredTransform
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }

        videoLayerInstruction.setTransform(videoAssetTrack!.preferredTransform, at: CMTime.zero)
        videoLayerInstruction.setOpacity(0.0, at: duration)

        mainInstruction.layerInstructions = [videoLayerInstruction]

        let mainComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMakeWithSeconds(1.0 / 60.0, preferredTimescale: 90_000)
        var naturalSize: CGSize
        if isPortrait {
            naturalSize = CGSize(width: videoAssetTrack!.naturalSize.height, height: videoAssetTrack!.naturalSize.width)
        } else {
            naturalSize = videoAssetTrack!.naturalSize
        }

        mainComposition.renderSize = CGSize(width: naturalSize.width, height: naturalSize.height)

        let tempName = "temp-threads.mov"
        let tempURL = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent(tempName))
        do {
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(at: tempURL)
            }
            _ = try? FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing temp file.")
        }
        // create final video using export session
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = tempURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = mainComposition
        encodingView.isHidden = false
        print("Exporting video...")
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession.status {
                // Success
                case .completed:
                    print("Saving to Photos Library...")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportSession.outputURL!)
                    }) { success, error in
                        if success {
                            print("Added video to library - success: \(success), error: \(String(describing: error?.localizedDescription))")
                        } else {
                            print("Added video to library - success: \(success), error: \(String(describing: error!.localizedDescription))")
                        }

                        _ = try? FileManager.default.removeItem(at: tempURL)
                        _ = try? FileManager.default.removeItem(at: url)
                    }
                    
                    // ToDo: show
                    print("Export session completed")
                // Status other than success
                case .cancelled, .exporting, .failed, .unknown, .waiting:
                    print("Export status: \(exportSession.status.rawValue)")
                    print("Reason: \(String(describing: exportSession.error))")
                }
            }
        }
    }
}
extension TimeLapsViewController {
    static func instantiate() -> TimeLapsViewController {
        let viewController = UIStoryboard(name: "TimeLaps", bundle: nil).instantiateInitialViewController() as! TimeLapsViewController
        return viewController
    }
}
