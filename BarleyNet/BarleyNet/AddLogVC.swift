//
//  AddLogVC.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/18/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit

class AddLogVC: UIViewController {

    let barley:String = "http://barleynet.herokuapp.com/api/logs/"
    var data = UserDefaults.standard.object(forKey: "fields") as? [String]
    var damage = ["Hail", "Pests", "Disease", "Discoloration", "Lodging"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadButton(_ sender: UIBarButtonItem) {
        let lat = UserDefaults.standard.object(forKey: "lat") as! CGFloat
        let lon = UserDefaults.standard.object(forKey: "lon") as! CGFloat
//        locationPostRequest(withURL: "http://barleynet.herokuapp.com/api/location", andPost: "latitude=\(lat)&longitude=\(lon)")
//        let location = UserDefaults.standard.object(forKey: "location") as! String
        postRequest(withURL: "http://barleynet.herokuapp.com/api/logs", andPost: "location=57dec56ab6a37800113ffead&yield=\(94052)&red_flags=\(true)&field=57ddd756e59ee060ec05a881")
    }
    
    
    
    @IBOutlet weak var agroAlertSwitch: UISwitch!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func cameraButton(_ sender: UIButton) {
        
    }
    @IBAction func gpsCoordinateButton(_ sender: UIButton) {
        gpsCoordinateBtn.setTitle("GPS Coordinates: (43.095181, -79.006424", for: .normal)
    }
    
    @IBOutlet weak var gpsCoordinateBtn: UIButton!
    var hail = false;
    var pest = false;
    var disease = false;
    var discoloration = false;
    var lodging = false;
    
    @IBAction func hailButton(_ sender: UIButton) {
        if(!hail) {
            hailFlag.tintColor = UIColor.red
        } else {
            hailFlag.tintColor = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        }
        hail = !hail
    }
    @IBOutlet weak var hailFlag: UIButton!
    @IBAction func pestButton(_ sender: UIButton) {
        if(!pest) {
            pestFlag.tintColor = UIColor.red
        } else {
            pestFlag.tintColor = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        }
        pest = !pest
    }
    @IBOutlet weak var pestFlag: UIButton!
    @IBAction func diseaseButton(_ sender: UIButton) {
        if(!disease) {
            diseaseFlag.tintColor = UIColor.red
        } else {
            diseaseFlag.tintColor = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        }
        disease = !disease
    }
    @IBOutlet weak var diseaseFlag: UIButton!
    @IBAction func discolorationButton(_ sender: UIButton) {
        if(!discoloration) {
            discolorationFlag.tintColor = UIColor.red
        } else {
            discolorationFlag.tintColor = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        }
        discoloration = !discoloration
    }
    @IBOutlet weak var discolorationFlag: UIButton!
    @IBAction func lodgingButton(_ sender: UIButton) {
        if(!lodging) {
            lodgingFlag.tintColor = UIColor.red
        } else {
            lodgingFlag.tintColor = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        }
        lodging = !lodging
    }
    @IBOutlet weak var lodgingFlag: UIButton!
    
    func postRequest(withURL url:String, andPost post:String) {
        let myURL = URL(string: url)
        var request = URLRequest(url: myURL!)
        request.httpMethod = "POST"
        let postString = post
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                print(json)

            } catch {
                print("JSON serialization failed")
            }
        }
        task.resume()
    }
    
    func locationPostRequest(withURL url:String, andPost post:String) {
        let myURL = URL(string: url)
        var request = URLRequest(url: myURL!)
        request.httpMethod = "POST"
        let postString = post
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                UserDefaults.standard.set(json["_id"]!, forKey: "location")
            } catch {
                print("JSON serialization failed")
            }
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
