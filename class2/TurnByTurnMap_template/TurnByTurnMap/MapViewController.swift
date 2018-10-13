//
//  MapViewController.swift
//  TurnByTurnMap
//
//  Created by Sam Zhang on 5/19/18.
//  Copyright © 2018 Sam Zhang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {

    // MARK: - outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionLInfo: UILabel!
    
    
    // MARK: - instance

    
    // MARK: - variables

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setups
        // setup locationManager

        
        // setup mapView
 
        
        // setup Search Bar

    }

    // MARK: - protocols
    /*Core Location*/
    // Get curerent location

    
    // Enter Region

    
    
    // MARK: - logic
    /**路线**/
    // 显示路线

    
    // 计算路线

    
    // turn by turn 处理

    
    
    // update 语音，文字

    
    /**搜索**/
    // Clean Map

    
    /**大头针**/
    // 显示大头针

    
    // 大头针气泡

    
    // 点击气泡触发

    
}
