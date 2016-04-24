//
//  ViewController.swift
//  Yonder
//
//  Created by Miguel Melendez on 4/23/16.
//  Copyright © 2016 Miguel Melendez. All rights reserved.
//

import UIKit
import CoreLocation

var currentLat: Double = 0.0
var currentLon: Double = 0.0
var currentDir: String = "ND"

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    @IBAction func waterDrop(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Find user location using built-in geolocation
        let userLocation: CLLocation = locations[0] as CLLocation
        currentLat = userLocation.coordinate.latitude
        currentLon = userLocation.coordinate.longitude
        latLabel.text = "Lat: \(String(toFixed(currentLat)))"
        lonLabel.text = "Lon: \(String(toFixed(currentLon)))"
    }
    
    func toFixed(num: Double) -> Double {
        return Double(round(1000*num)/1000)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let compassReading = newHeading.magneticHeading
        let coordNames = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        var coordIndex: Int = Int(round(compassReading / 45))
        if (coordIndex < 0) {
            coordIndex = coordIndex + 8
        }
        currentDir = coordNames[coordIndex]
//        print(coordNames[coordIndex])
    }

}