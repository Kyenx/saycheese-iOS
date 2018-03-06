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
    
    var toggleRecord : Bool = false
    var makeProfile : Bool = false
    var timer = Timer ()
    var errorCounter = 0
    var emotionArray : [String:Float] = ["anger": 0.0,
        "contempt": 0.0,
        "disgust": 0.0,
        "fear": 0.0,
        "happiness": 0.0,
        "neutral": 0.0,
        "sadness": 0.0,
        "surprise": 0.0]
    
    
    var userProfile = [String:String]()
    //var userProfile : [String:String] = ["gender":"n/a","age":"0","emotion":"n/a","accessories":"n/a", "facialhair":"n/a"]
    
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
    
    func resetEmotionsArray(){
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        if(!self.toggleRecord){
            self.toggleRecord = !self.toggleRecord
            captureButton.alpha = 0.5
            /*self.toggleRecord = !self.toggleRecord
            self.userProfile.removeAll()
            for key in self.emotionArray.keys {emotionArray[key] = 0.0}
            self.makeProfile = false
            captureButton.alpha = 0.5
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.takeSnap), userInfo: nil, repeats: true)*/
            cameraController.startRecording()
        } else {
            self.toggleRecord = !self.toggleRecord
            captureButton.alpha = 1
            /*timer.invalidate()
            self.toggleRecord = !self.toggleRecord
            captureButton.alpha = 1
            let mEmo = emotionArray.max { a, b in a.value < b.value }
            if let m = mEmo?.key {
                self.userProfile["emotion"] = m
            }
            
            print("FINAL:::::::::::::",self.userProfile)
            presentMessage(self.userProfile)*/
            cameraController.stopRecording()
        }
        
        
    }
    
    func presentMessage(_ userArray:[String:String]){
        
        var alert_message = ""
        
        for (key, val) in userArray {
            if val != "" {
            alert_message += "\(key) : \(val) \n"
            }
        }
        
        let alertController = UIAlertController(title: "Results", message:alert_message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil)) //{ action in
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func takeSnap(){
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
    
    func uploadPhoto(_ img: UIImage) {
        //let imageData = UIImageJPEGRepresentation(photo, 1.0)
        //let imageString = imageData?.base64EncodedString()
        //print(imageString!)
        //let img = UIImage.init(named: "hip1")!
        session.detectFaces(facesPhoto: img, completion: {(json, error) in
            guard let res = json else {
                print(error ?? "Image capture error")
                return
            }
            
            if let js = res as? [[String:Any]]{
                if (!js.isEmpty) {
                if let fA = js[0]["faceAttributes"] as? [String:Any] {
                    //print("fa:",fA)
                    if let emo = fA["emotion"] as? [String:Float] {
                        print("emo: ", emo)
                        
                        let mEmo = emo.max { a, b in a.value < b.value }
                        if let m = mEmo {
                            print(m.key)
                        //for (key, val) in emo {
                           //print(key,val)
                            self.emotionArray[m.key] = self.emotionArray[m.key]! + m.value
                        //}
                        }
                    }
                    
                    if(!self.makeProfile) {
                    //print("heelo:", res)
                    //print("fa:",fA)
                    if let acces = fA["accessories"] as? [[String:Any]] {
                        var sString = ""
                        for single in acces {
                        //guard let type = acces["type"] as? String else {return}
                            if let type = single["type"] as? String {
                                sString += type
                            }
                        }
                        self.userProfile["accessories"] = sString
                    }
                    
                    if let gen = fA["gender"] as? String {
                        //print("gender!!!:", gen)
                        self.userProfile["gender"] = gen
                    }
                    if let age = fA["age"] as? Double {
                        
                            self.userProfile["age"] = String(age)
                    }
                        
                    if let faceH = fA["facialHair"] as? [String:Double] {
                        var sString = ""
                        for (key,val) in faceH {
                            if val > 0.3 {
                                sString += "\(key), "
                            }
                        }
                        self.userProfile["facialhair"] = sString
                        
                    }
                        if let makeUp = fA["makeup"] as? [String:Bool] {
                            var sString = ""
                            for (key,val) in makeUp {
                                if val {
                                    sString += "\(key), "
                                }
                            }
                            self.userProfile["makeup"] = sString
                            
                        }
                        self.makeProfile = !self.makeProfile
                        
                    }
                }
                } else {
                    print("empty json back")
                    if self.errorCounter > 3 {
                        self.timer.invalidate()
                        DispatchQueue.main.async() {
                        self.captureButton.alpha = 1
                        }
                    }
                    self.errorCounter += 1
                }
            }
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
            
            
            //The one
            cameraController.prepare()
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
            
            
        }
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        
        configureCameraController()
        
        //session.getRequest()
        
    }

    func playVideo(_ videoRec : Any){
        let videoRecorded = videoRec as! URL
        self.performSegue(withIdentifier: "showVideo", sender: videoRecorded)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! PlaybackViewController
        vc.videoURL = sender as! URL
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

