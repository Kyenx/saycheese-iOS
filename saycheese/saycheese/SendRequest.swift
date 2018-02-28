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

    let initUrl = "https://jsonplaceholder.typicode.com/posts"
    
    
    func getRequest () {
        
    
        guard let targetUrl = URL(string:initUrl) else {return }
        
       // do {
        let request = URLRequest(url: targetUrl)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
                if error != nil {
                    print(error)
                } else {
                    
                    if let usableData = data {
                        //let dataString = NSString(data: usableData, encoding: String.Encoding.utf8.rawValue)
                        //if let returnData = dataString {
                            //print(returnData)
                        //}
                        //print(usableData) //JSONSerialization
                        let json = try! JSONSerialization.jsonObject(with: usableData, options: [])
                        if let js = json as? [[String:AnyObject]]{
                            //print(js)
                            if let title = js[0]["title"] as? String {
                                print(title)
                            }
                        }
                        
                    }
                }
                
            }
            task.resume()
            
       // } catch {
            
        //}
    
    
    
    }
}
