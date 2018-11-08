//
//  ViewController.swift
//  face_detection
//
//  Created by Soubhi Hadri on 3/3/18.
//  Copyright © 2018 hadri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageview: UIImageView!
    var opencv:OpencvWrapper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        opencv = OpencvWrapper()
        let dispatchGroup=DispatchGroup()
        dispatchGroup.enter()
        opencv?.setupCamera(imageview)
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            self.opencv.startCamera()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func flip_camera(_ sender: UIButton) {
        opencv?.flipCamera()
    }
    
}

