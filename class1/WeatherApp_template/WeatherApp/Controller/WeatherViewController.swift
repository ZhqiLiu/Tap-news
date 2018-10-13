//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Yichi Zhang on 3/29/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import CoreLocation

import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, changeCityDelegate {
    


    // MARK: - API Constants
    let WEATHER_API = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "!YOUR_APP_ID!"

    
    // MARK: - Instance declaration


    // MARK: - outlets
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var degreeUnit: UISegmentedControl!
    
    // MARK: - Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager

        
    }
    
    // MARK: - Restful
    // getWeatherData from open weather api

    
    // MARK: - update Model
    // updateWeatherModel from restful request

    
    // MARK: - update UI
    // updateUIWithWeatherData from Model



    // MARK: - Degree Unit Toggle
    @IBAction func degreeUnitToggle(_ sender: UISegmentedControl) {

    }
    
    // MARK: - segue to change city VC
    @IBAction func goToChangCityVC() {
        
    }
    
    // MARK: - prepare segue to change city name

    
    // MARK: - update city delegate

    
    // MARK: - callback didUpdateLocations


    // MARK: - Get current location function
    @IBAction func getMyLocationWeather() {

    }
    
}
