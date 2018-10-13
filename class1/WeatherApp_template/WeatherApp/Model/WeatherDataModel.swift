//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Yichi Zhang on 3/29/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import Foundation

class WeatherDataModel {
    var city = ""
    
    var weatherIconName = ""
    
    var condition = 0
    var temperature: Double = 0
    
    func updateWeatherIcon(condition: Int) -> String {
        switch condition {
        case 200...210:
            return "tstormwithrain"
        case 211...299:
            return "storm"
        case 500...501:
            return "lightrain"
        case 502...599:
            return "rain"
        case 600...601:
            return "lightsnow"
        case 600...699:
            return "snow"
        case 700...750:
            return "fog"
        case 800:
            return "sunny"
        case 801...802:
            return "fewclouds"
        case 803...804:
            return "clouds"
        default:
            return "unknown"
        }
    }
    
}
