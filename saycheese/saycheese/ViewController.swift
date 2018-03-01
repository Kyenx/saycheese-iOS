//
//  ViewController.swift
//  saycheese
//
//  Created by Jovin Kyenkungu on 2018-02-27.
//  Copyright © 2018 Jovin K. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var toggleCameraButton: UIButton!
    
    @IBAction func toggleFlash(_ sender: Any) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "flash"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "flash-on"), for: .normal)
        }
        
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
       /* switch cameraController.currentCameraPosition {
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            
        case .some(.rear):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        case .none:
            return
        }*/
        
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        cameraController.captureImage {(imagez, error) in
            guard let image = imagez else {
                print(error ?? "Image capture error")
                return
            }
            
            self.uploadPhoto(image)
            
            /*try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }*/
            
        }
        
    }
    
    func uploadPhoto(_ photo: UIImage) {
        let imageData = UIImageJPEGRepresentation(photo, 1.0)
        //let imageString = imageData?.base64EncodedString()
        //print(imageString!)
        let img = UIImage.init(named: "download")!
        session.detectFaces(facesPhoto: photo, completion: {(json, error) in
            guard let res = json else {
                print(error ?? "Image capture error")
                return
            }
            print("heelo:", res)
        })
    }
    
    
    
    
    var session = SendRequest()
    
    let cameraController = CameraController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        func configureCameraController() {
            /*cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }*/
            //let client = MPOFaceServiceClient(subscriptionKey: "jj")
            
            cameraController.prepare()
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
            
        }
        
        configureCameraController()
        
        //session.getRequest()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

