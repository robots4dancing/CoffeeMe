//
//  ViewController.swift
//  CoffeeMe
//
//  Created by ANI on 2/28/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet var coffeeMap :MKMapView!
    
    var locationMgr = CLLocationManager()
    
    //MARK: - Map View Methods
    
    func zoomToPins() {
        coffeeMap.showAnnotations(coffeeMap.annotations, animated: true)
    }
    
    func zoomToLocation(lat: Double, lon: Double, radius: Double) {
        if lat == 0 && lon == 0 {
            print("Invalid Data")
        } else {
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let viewRegion = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
            let adjustedRegion = coffeeMap.regionThatFits(viewRegion)
            coffeeMap.setRegion(adjustedRegion, animated: true)
        }
    }
    
    func annotateMapLocations() {
        var pinsToRemove = [MKPointAnnotation]()
        for annotation in coffeeMap.annotations {
            if annotation is MKPointAnnotation {
                pinsToRemove.append(annotation as! MKPointAnnotation)
            }
        }
        coffeeMap.removeAnnotations(pinsToRemove)
        
        let pa1 = MKPointAnnotation()
        pa1.coordinate = CLLocationCoordinate2D(latitude: 42, longitude: -83)
        pa1.title = "Southern Ontario Waterfront"
        pa1.subtitle = "Wow it's nice!"
        
        let pa2 = MKPointAnnotation()
        pa2.coordinate = CLLocationCoordinate2D(latitude: 42.123, longitude: -83.123)
        pa2.title = "Somewhere Someplace"
        pa2.subtitle = "Who knows where."
        
        let pa3 = MKPointAnnotation()
        pa3.coordinate = CLLocationCoordinate2D(latitude: 42.234, longitude: -83.234)
        pa3.title = "I Wonder Where"
        pa3.subtitle = "I hope this works."
        
        coffeeMap.addAnnotations([pa1, pa2, pa3])
    //    zoomToPins()
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationMonitoring()
        annotateMapLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLoc = locations.last!
        print("Last Loc: \(lastLoc.coordinate.latitude), \(lastLoc.coordinate.longitude)")
        zoomToLocation(lat: lastLoc.coordinate.latitude, lon: lastLoc.coordinate.longitude, radius: 500)
        manager.stopUpdatingLocation()
    }
    
    //MARK: - Location Authorization Methods
    
    func turnOnLocationMonitoring() {
        locationMgr.startUpdatingLocation()
        coffeeMap.showsUserLocation =  true
    }
    
    func setupLocationMonitoring() {
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                turnOnLocationMonitoring()
            case .denied, .restricted:
                print("Hey Turn Us Back On in Settings!")
            case .notDetermined:
                if locationMgr.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
                    locationMgr.requestAlwaysAuthorization()
                }
            }
        } else {
            print("Hey Turn Location On in Settings!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setupLocationMonitoring()
    }
    
}
