//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Yichi Zhang on 3/29/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {

    @IBOutlet weak var cityNameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    var delegate: changeCityDelegate?
    
    @IBAction func backToWeatherVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeCity() {
        if delegate != nil {
            let city = cityNameTextfield.text!
            delegate?.changeCity(city: city)
            backToWeatherVC()
        }
    }
    

}
