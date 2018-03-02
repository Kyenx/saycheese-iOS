//
//  SendRequest.swift
//  saycheese
//
//  Created by Jovin Kyenkungu on 2018-02-27.
//  Copyright © 2018 Jovin K. All rights reserved.
//

import UIKit
import Foundation

class SendRequest: NSObject {
    
    enum FaceAPIResult<T: Any, Error: Swift.Error> {
        case Success(T)
        case Failure(Error)
    }
    
    enum FaceApiError: Swift.Error {
        case unexpectedError
        case serviceError
        case serializeError
    }

    let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    
    func getRequest () {
        //Create URLobject from urlstring
        guard let targetUrl = URL(string:urlString) else {return }

        let request = URLRequest(url: targetUrl)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
                if error != nil {
                    print(error!)
                } else {
                    
                    if let usableData = data {
                        //Serialize json output
                        let json = try! JSONSerialization.jsonObject(with: usableData, options: [])
                        //2D array for multi json output, else [String:AnyObject]
                        if let js = json as? [[String:AnyObject]]{
                            
                            if let title = js[0]["title"] as? String {
                                print(title)
                            }
                        }
                    }
                }
            }
            task.resume()
    
    
    }
    
   func detectFaces(facesPhoto: UIImage, completion: @escaping (Any?, Error?) -> Void) {
    
    let attr = "age,facialHair,gender,smile,emotion,makeup,accessories,exposure,noise"
    let url = "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=false&returnFaceLandmarks=false&returnFaceAttributes=\(attr)"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("xx", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let pngRepresentation = UIImageJPEGRepresentation(facesPhoto, 1.0)
        
        let task = URLSession.shared.uploadTask(with: request as URLRequest, from: pngRepresentation) { (data, response, error) in
            
            if error != nil {
                completion(nil, FaceApiError.unexpectedError)
                return
            }
            else {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    if statusCode == 200 {
                       
                        completion(json, nil)
                            
                
                    }
                    else {
                        completion(nil, FaceApiError.serviceError)
                    }
                }
                catch {
                    completion(nil, FaceApiError.serializeError)
                }
            }
        }
        task.resume()
    }
}
