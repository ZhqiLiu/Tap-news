//
//  RegisterViewController.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 5/16/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerPressed() {
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            
            if error != nil {
                SVProgressHUD.dismiss()
                
                let registerFailureAlert = UIAlertController(title: "Register Error", message: "\(error!.localizedDescription) Please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                registerFailureAlert.addAction(okAction)
                self.present(registerFailureAlert, animated: true, completion: nil)
                
                print("registration failed, error: \(error!)")
            }
            else {
                print("registration successful")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "GetIntoNews", sender: self) //baby-sitter
            }
        })
    }
}
