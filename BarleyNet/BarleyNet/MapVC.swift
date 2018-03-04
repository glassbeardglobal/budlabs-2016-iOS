//
//  MapVC.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/17/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    let barley:String = "http://barleynet.herokuapp.com/api/contracts/"
    
    @IBOutlet var map: MKMapView!
    var manager:CLLocationManager!
    var fields: [String] = []

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
        let userLocation:CLLocation = locations[0]
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        UserDefaults.standard.set(latitude, forKey: "lat")
        UserDefaults.standard.set(longitude, forKey: "lon")
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: false)
        manager.stopUpdatingLocation()
    }
    
    func action(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            print("Gesture Recognized")
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCoordinate: CLLocationCoordinate2D = map.convert(touchPoint, toCoordinateFrom: self.map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            annotation.title = "New Place"
            annotation.subtitle = "One day I'll go here..."
            map.addAnnotation(annotation)
            
        }
    }
    
    func saveButtonAction() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFields(withURL: "\(barley)?id=\(UserDefaults.standard.object(forKey: "id") as! String)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "Map of \(UserDefaults.standard.object(forKey: "currentContractName"))"
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 0.5
        map.addGestureRecognizer(uilpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getFields(withURL url:String) {
        let myURL = URL(string: url)
        var request = URLRequest(url: myURL!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            do {
                print("getRequest:")
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                if let jsonArray = json as [AnyObject]! {
                    for object in jsonArray {
                        if let contract = object as? [String: AnyObject] {
                            if let fields = contract["fields"] as? [String] {
                                for f in fields {
                                    self.fields.append(f)
                                }
                            }
                        }
                    }
                } else {
                    print(json)
                }
                
            } catch {
                print("JSON serialization failed")
            }
            UserDefaults.standard.set(self.fields, forKey: "fields")
        }
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
