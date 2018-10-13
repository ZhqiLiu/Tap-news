//
//  NewsRecognitionViewController.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 1/10/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import TesseractOCR

class NewsRecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {

    let imagePicker = UIImagePickerController()
    let libraryImagePicker = UIImagePickerController()

    var tesseract = G8Tesseract(language:"eng")!
    
    @IBOutlet weak var outputText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        libraryImagePicker.delegate = self
        libraryImagePicker.sourceType = .photoLibrary
        libraryImagePicker.allowsEditing = false
        
        tesseract.delegate = self
    }


    @IBAction func takePhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func selectPhotoFromLibrary() {
        present(libraryImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            tesseract.image = pickedImage.g8_blackAndWhite()
            
            DispatchQueue.global().async {
                self.tesseract.recognize()
                DispatchQueue.main.async {
                    self.outputText.text = self.tesseract.recognizedText
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        DispatchQueue.main.async {
            self.outputText.text = "Recognition Progress %: \(tesseract.progress)"
        }
        print("Recognition Progress %: ",tesseract.progress)
    }
    
}
