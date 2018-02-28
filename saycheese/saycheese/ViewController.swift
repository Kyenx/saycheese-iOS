//
//  ViewController.swift
//  saycheese
//
//  Created by Jovin Kyenkungu on 2018-02-27.
//  Copyright © 2018 Jovin K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var session = SendRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session.getRequest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

