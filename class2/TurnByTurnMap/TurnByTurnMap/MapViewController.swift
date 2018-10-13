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
    let locationManager = CLLocationManager()
    
    // MARK: - variables
    var currentCoordinate: CLLocationCoordinate2D!
    var steps = [MKRouteStep]()
    var currentPolyline: MKPolyline!
    var speaker = AVSpeechSynthesizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setups
        // setup locationManager
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        // setup mapView
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading // Map follows user location and rotates
        
        // setup Search Bar
        searchBar.delegate = self
    }

    // MARK: - protocols
    /*Core Location*/
    // Get curerent location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            print("Location Not Fount")
            return
        }
        
//        print(currentLocation)
        currentCoordinate = currentLocation.coordinate
    }
    
    // Enter Region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering in region list: \(region.identifier)")
        updateDirectionInsctruction(stepCount: Int(region.identifier)!)
    }
    
    
    // MARK: - logic
    /**路线**/
    // 显示路线
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = UIColor.blue
            render.lineWidth = 5
            return render
        }
        else if overlay is MKCircle {
            let render = MKCircleRenderer(circle: overlay as! MKCircle)
            render.strokeColor = UIColor.brown
            render.alpha = 0.3
            return render
        }
        
        return MKOverlayRenderer()
    }
    
    // 计算路线
    func getDirection(to destinationMapItem: MKMapItem) {
//        print(destinationMapItem.placemark)
        
        // source
        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        // setup calculate direction request
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // make direction calculation
        let direction = MKDirections(request: directionRequest)
        direction.calculate(completionHandler: { (res, err) in
            if err != nil {
                print("Calculate direction error: \(err!)")
            }
            else {
                if let response = res {
                    let routes = response.routes    // a list of routes
                    let optimalRoute = routes.first!
                    
                    // remove prevous rendered polyline before render a new one
                    // Won't remove geofence circles. 给用户的版本中并不会显示那些圈圈
                    if self.currentPolyline != nil {
                        self.mapView.removeOverlays([self.currentPolyline])
                    }
                    
                    self.currentPolyline = optimalRoute.polyline
                    
                    self.mapView.addOverlays([optimalRoute.polyline], level: .aboveRoads)
                    
                    self.steps = optimalRoute.steps
                    
                    self.generateTurnByTurnInstruction(self.steps)
                    
                    self.updateDirectionInsctruction(stepCount: 0)
                }
            }
        })
        
    }
    
    // turn by turn 处理
    func generateTurnByTurnInstruction(_ steps: [MKRouteStep]) {
        // clean all other monitored regions
        // Won't remove geofence circles. 给用户的版本中并不会显示那些圈圈
        self.locationManager.monitoredRegions.forEach {
            self.locationManager.stopMonitoring(for: $0)
        }
        
        // calculate new
        for (i, step) in steps.enumerated() {
            print("\(step.instructions, step.distance), \(step.polyline.coordinate), identifier: \(i)")
            let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20, identifier: "\(i)")
            
            self.locationManager.startMonitoring(for: region)
            
            let circle = MKCircle(center: region.center, radius: region.radius)
            mapView.add(circle)
        }
    }
    
    
    // update 语音，文字
    func updateDirectionInsctruction(stepCount: Int) {
        var info = "Calculating"
        if stepCount == steps.count - 1 {
            info = "\(steps[stepCount].instructions)"
        }
        else {
            info = "\(steps[stepCount].instructions) and move \(steps[stepCount + 1].distance) meters"
        }
        
        directionLInfo.text = info
        speaker.speak(AVSpeechUtterance(string: info))
    }
    
    /**搜索**/
    // Clean Map
    func cleanMap() {
        directionLInfo.text = ""
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Disable search after searchPressed
        searchBar.endEditing(true)
        cleanMap()
        
        // setup search request
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)) //中心 + “半径”
        localSearchRequest.region = region
        
        // make search request
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start(completionHandler: { (res, err) in
            if err != nil {
                print("Search response error: \(err!)")
            }
            else {
                let searchResults = res?.mapItems // A list of search results
//                print(searchResults)
                self.displayAnnotation(mapItems: searchResults!)
            }
        })
        
    }
    
    /**大头针**/
    // 显示大头针
    func displayAnnotation(mapItems: [MKMapItem]) {
        for mapItem in mapItems {
            // setup destination pin
            let annotation = MKPointAnnotation()
            
            annotation.title = mapItem.name
            annotation.subtitle = mapItem.placemark.title
            annotation.coordinate = mapItem.placemark.coordinate
            
            // Add pin to mapview
            mapView.addAnnotation(annotation)
        }
    }
    
    // 大头针气泡
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //User location pin
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "SearchResult"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let annotationPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // drop animates
            annotationPinView.animatesDrop = true
            // 显示子标题和bubble
            annotationPinView.canShowCallout = true
            //bubble右侧控件
            annotationPinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = annotationPinView
        }
        
        annotationView?.annotation = annotation
        
        return annotationView
    }
    
    // 点击气泡触发
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! MKPointAnnotation
        getDirection(to: MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate)))
    }
    
}
