//
//  MapViewController.swift
//  Tap_New_iOS
//
//  Created by Yichi Zhang on 1/9/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var newsMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsMapView.delegate = self

        //大头针
        let UMAnnotation = MKPointAnnotation()
        UMAnnotation.coordinate = CLLocation(latitude: 42.2780436, longitude: -83.7404128).coordinate
        UMAnnotation.title = "U of M"
        UMAnnotation.subtitle = "Number of News: 2"
        newsMapView.addAnnotation(UMAnnotation)
        
        let CMUAnnotation = MKPointAnnotation()
        CMUAnnotation.coordinate = CLLocation(latitude: 40.4423545, longitude: -79.9457565).coordinate
        CMUAnnotation.title = "CMU"
        CMUAnnotation.subtitle = "Number of News: 2"
        newsMapView.addAnnotation(CMUAnnotation)
        
        let appleAnnotation = MKPointAnnotation()
        appleAnnotation.coordinate = CLLocation(latitude: 37.33182, longitude: -122.0333687).coordinate
        appleAnnotation.title = "APPLE"
        appleAnnotation.subtitle = "Number of News: 2"
        newsMapView.addAnnotation(appleAnnotation)
        
        let chicagoAnnotation = MKPointAnnotation()
        chicagoAnnotation.coordinate = CLLocation(latitude: 41.8336478, longitude: -87.8720472).coordinate
        chicagoAnnotation.title = "Chicago"
        chicagoAnnotation.subtitle = "Number of News: 2"
        newsMapView.addAnnotation(chicagoAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin") ?? MKAnnotationView()
        annotationView.canShowCallout = true

        if annotation.title! == "U of M" {
            annotationView.image = UIImage(named: "um_icon_29pt")
        }
        else if annotation.title! == "CMU" {
            annotationView.image = UIImage(named: "cmu_icon_29pt")
        }
        else if annotation.title! == "APPLE" {
            annotationView.image = UIImage(named: "icon_29pt")
        }
        else {
            return nil
        }
        
        return annotationView
    }

}
