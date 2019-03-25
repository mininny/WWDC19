//
//  FaceRecogViewController.swift
//  PlaygroundBook
//
//  Created by Minhyuk Kim on 24/03/2019.
//


import UIKit
import SceneKit
import ARKit
import AVFoundation

@available(iOS 11.0, *)
public class FaceRecogViewController: UIViewController, ARSCNViewDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var resultLabel = UILabel()
    var player: AVAudioPlayer?
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let previewView = UIView(frame: UIScreen.main.bounds)
        
        view.addSubview(previewView)
        previewView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        previewView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        let pictureButton = UIButton()
        let pictureImage = UIImage(named: "picture.png")
        pictureButton.setBackgroundImage(pictureImage, for: .normal)
        pictureButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)

        let pictureButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        pictureButtonView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        pictureButtonView.addSubview(pictureButton)
        
        pictureButton.translatesAutoresizingMaskIntoConstraints = false
        pictureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pictureButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pictureButton.centerXAnchor.constraint(equalTo: pictureButtonView.centerXAnchor).isActive = true
        pictureButton.centerYAnchor.constraint(equalTo: pictureButtonView.centerYAnchor).isActive = true
        
        pictureButtonView.widthAnchor.constraint(equalTo: pictureButton.widthAnchor, constant: 25).isActive = true
        pictureButtonView.heightAnchor.constraint(equalTo: pictureButton.heightAnchor, constant: 20).isActive = true
        pictureButtonView.layer.cornerRadius = 15
        
        view.addSubview(pictureButtonView)
        pictureButtonView.translatesAutoresizingMaskIntoConstraints = false
        pictureButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pictureButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        
        let resultLabelView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        resultLabelView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        resultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        resultLabel.text = "Total faces found:"
        resultLabel.sizeToFit()
        
        resultLabelView.addSubview(resultLabel)
        resultLabelView.widthAnchor.constraint(equalTo: resultLabel.widthAnchor, constant: 30).isActive = true
        resultLabelView.heightAnchor.constraint(equalTo: resultLabel.heightAnchor, constant: 20).isActive = true
        resultLabelView.layer.cornerRadius = 15
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.centerXAnchor.constraint(equalTo: resultLabelView.centerXAnchor).isActive = true
        resultLabel.centerYAnchor.constraint(equalTo: resultLabelView.centerYAnchor).isActive = true
        
        view.addSubview(resultLabelView)
        resultLabelView.translatesAutoresizingMaskIntoConstraints = false
        resultLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        resultLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.connection?.videoOrientation = .landscapeRight
            
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            captureSession?.addOutput(capturePhotoOutput!)
            
            captureSession?.startRunning()
        } catch {
            print(error)
        }
        
    }
    //Plays sound with AVFoundation
    func playSound(name: String, ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func takePhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        resultLabel.text = ">>>"
        let flashView = UIView(frame: self.view.bounds)
        flashView.backgroundColor = .black
        flashView.alpha = 1
        view.addSubview(flashView)
        UIView.animate(withDuration: 0.5, animations: {
            flashView.alpha = 0.0
        }) { (finished) in
            flashView.removeFromSuperview()
        }
        
        //Photo Setting
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        //Take Photo
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

}

@available(iOS 11.0, *)
extension FaceRecogViewController : AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        //convert photo
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        
        let faceImage = CIImage(image: capturedImage!)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorSmile: true])
        
        //Detect faces and features
        let faces = faceDetector?.features(in: faceImage!, options: [CIDetectorSmile: true]) as! [CIFaceFeature]
        resultLabel.text = "Number of faces: \(faces.count)"
        resultLabel.sizeToFit()
        for face in faces{
            playSound(name: "tada", ext: "wav")
            if face.hasSmile{
                let smileLabelView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
                let smileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
                smileLabel.text = "You Smiled!!😀"
                smileLabelView.backgroundColor = UIColor(white: 1, alpha: 0.8)
                smileLabel.sizeToFit()
                
                smileLabelView.addSubview(smileLabel)
                smileLabelView.widthAnchor.constraint(equalTo: smileLabel.widthAnchor, constant: 30).isActive = true
                smileLabelView.heightAnchor.constraint(equalTo: smileLabel.heightAnchor, constant: 20).isActive = true
                smileLabelView.layer.cornerRadius = 20
                smileLabel.translatesAutoresizingMaskIntoConstraints = false
                smileLabel.centerXAnchor.constraint(equalTo: smileLabelView.centerXAnchor).isActive = true
                smileLabel.centerYAnchor.constraint(equalTo: smileLabelView.centerYAnchor).isActive = true
                
                UIView.animate(withDuration: 3, animations: {
                    self.view.addSubview(smileLabelView)
                    smileLabelView.translatesAutoresizingMaskIntoConstraints = false
                    smileLabelView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                    smileLabelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                }) { (finished) in
                    smileLabelView.removeFromSuperview()
                }
            }
            print("Is smile : \(face.hasSmile)")
        }
    }
}

