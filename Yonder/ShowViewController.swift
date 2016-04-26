//
//  ShowViewController.swift
//  Yonder
//
//  Created by Miguel Melendez on 4/23/16.
//  Copyright © 2016 Miguel Melendez. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        getNearestWaterSource()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getNearestWaterSource() {

        let url = NSURL(string: "https://data.waterpointdata.org/resource/gihr-buz6.json?$where=within_circle(location,\(testLat),\(testLon), 5000)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            if let urlContent = data {
                print(1)
                do {
                    var counter = 0
                    var nearestDistance: Double = 5000
                    var nearestDirection = ""
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)

                    for x in 0 ..< jsonResult.count {
                        var lat = ""
                        var lon = ""
                        if (jsonResult[x]["lat_deg"] != nil) {
                            lat = jsonResult[x]["lat_deg"] as! String
                        }
                        if (jsonResult[x]["lon_deg"] != nil) {
                            lon = jsonResult[x]["lon_deg"] as! String
                        }
                        if (lat != "" && lon != "") {
                            if (self.findDistance(Double(lat)!, lon: Double(lon)!) < nearestDistance) {
                                nearestDistance = self.findDistance(Double(lat)!, lon: Double(lon)!)
                                nearestDirection = self.findDirection(Double(lat)!, lon: Double(lon)!)
                                counter = x
                            }
                            
                        }

                    }
                    if (jsonResult[counter]["water_source"] != nil) {
                        let waterSource = jsonResult[counter]["water_source"] as! String
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.textLabel.text = "The nearest water source is a \(waterSource.lowercaseString) and is \(nearestDistance) miles away due \(nearestDirection). You are currently heading \(currentDir)."
                        })
                        
                    }

                } catch {
                    print("JSON Serialization Failed.")
                }
            } else {
                self.textLabel.text = "There are no water sources in this area."
            }
        }
        task.resume()
    }
    
    func findDistance(lat: Double, lon: Double) -> Double {
        let lat1 = lat
        let lon1 = lon
        let lat2 = testLat
        let lon2 = testLon
        
        // Radius of the earth in:  1.609344 miles,  6371 km  | var R = (6371 / 1.609344)
        let R = 3958.7558657440545;
        let dLat = toRad(lat2-lat1);
        let dLon = toRad(lon2-lon1);
        let a = sin(dLat/2) * sin(dLat/2) +
            cos(toRad(lat1)) * cos(toRad(lat2)) *
            sin(dLon/2) * sin(dLon/2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        let d = R * c;
        return toFixed(d)
    }
    
    func toRad(value: Double) -> Double {
        // Converts numeric degrees to radians
        return value * M_PI / 180;
    }
    
    func toFixed(num: Double) -> Double {
        return Double(round(1000*num)/1000)
    }
    
    func findDirection(lat: Double, lon: Double) -> String {
        let lat1 = lat
        let lon1 = lon
        let lat2 = testLat
        let lon2 = testLon
    
        let radians = getAtan2((lon1 - lon2), x: (lat1 - lat2))
    
        let compassReading = radians * (180 / M_PI)
    
        var coordNames = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        var coordIndex: Int = Int(round(compassReading / 45))
        if (coordIndex < 0) {
            coordIndex = coordIndex + 8
        }
    
        return coordNames[coordIndex]
    }
    
    func getAtan2(y: Double, x: Double) -> Double {
        return atan2(y, x)
    }
    
}