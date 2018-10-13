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
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    // MARK: - outlets
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var degreeUnit: UISegmentedControl!
    
    // MARK: - Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters  // 定位准确性
        locationManager.requestAlwaysAuthorization()

        locationManager.startUpdatingLocation() // Asycn
        locationManager.startMonitoringSignificantLocationChanges() // Monitor change
        
    }
    
    // MARK: - Restful
    // getWeatherData from open weather api
    func getWeatherData(url: String) {
        Alamofire.request(url, method: .get).responseJSON(completionHandler: {
            res in
            if res.result.isSuccess {
                print("request succeed!")
                
                let weatherData = JSON(res.result.value!)
                
                if weatherData["cod"].int! < 400 {
                    print(weatherData)
                    self.updateWeatherModel(data: weatherData)
                }
                else {
                    print("Weather unavailable")
                }
            }
            else {
                print("Internet issue: \(res)")
            }
            
        })
    }

    
    // MARK: - update Model
    // updateWeatherModel from restful request
    func updateWeatherModel(data: JSON) {
        var tempreatureData = data["main"]["temp"].double!
        
        if degreeUnit.titleForSegment(at: degreeUnit.selectedSegmentIndex) == "C" {
            tempreatureData -= 273.15
        }
        
        weatherDataModel.temperature = tempreatureData
        weatherDataModel.city = data["name"].stringValue
        weatherDataModel.condition = data["weather"][0]["id"].int!
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        updateWeatherViews()
        
    }
    
    // MARK: - update UI
    // updateUIWithWeatherData from Model
    func updateWeatherViews() {
        city.text = weatherDataModel.city
        temperature.text = String(round(weatherDataModel.temperature)) + "°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }


    // MARK: - Degree Unit Toggle
    @IBAction func degreeUnitToggle(_ sender: UISegmentedControl) {
        if sender.titleForSegment(at: sender.selectedSegmentIndex) == "K" {
            weatherDataModel.temperature += 273.15
        }
        else if sender.titleForSegment(at: sender.selectedSegmentIndex) == "C" {
            weatherDataModel.temperature -= 273.15
        }
        
        updateWeatherViews()
    }
    
    // MARK: - segue to change city VC
    @IBAction func goToChangCityVC() {
        performSegue(withIdentifier: "goToChangeCityVC", sender: self)
    }
    
    // MARK: - prepare segue to change city name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChangeCityViewController
        destinationVC.delegate = self
    }
    
    // MARK: - update city delegate
    func changeCity(city: String) {
        
        let url = "\(WEATHER_API)?q=\(city.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&appid=\(APP_ID)"
        getWeatherData(url: url)
    }
    
    // MARK: - callback didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {  //[not very accurate -> accurate]
            if location.horizontalAccuracy > 0 {    // minus is invalid
                locationManager.stopUpdatingLocation()
                
                let lat = String(location.coordinate.latitude)
                let lon = String(location.coordinate.longitude)
                
                let url = "\(WEATHER_API)?lat=\(lat)&lon=\(lon)&appid=\(APP_ID)"
                getWeatherData(url: url)
            }
        }
    }

    // MARK: - Get current location function
    @IBAction func getMyLocationWeather() {
        print("get my loaction weather")
        locationManager.startUpdatingLocation()
    }
    
}
