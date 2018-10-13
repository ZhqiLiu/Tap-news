//
//  ImageRecognitionViewController.swift
//  ImageRecognition
//
//  Created by Yichi Zhang on 7/1/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import CoreML
import Vision   // 初步处理图片

// UIImagePickerControllerDelegate 选照片，UINavigationControllerDelegate 负责弹出
class ImageRecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var display: UILabel!
    
    //Instance

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup imagePicker

        
        // setup libraryImagePicker

    }

    @IBAction func tablePhoto(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func selectPhoto(_ sender: UIBarButtonItem) {
        
        
    }
    
    // image picker delegate，picker(imagePicker, libraryImagePicker), info(image information)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

    }

    // identifyImage
    func identifyImage(image: CIImage) {
        
        // create request

        
        // make request

    }
}
