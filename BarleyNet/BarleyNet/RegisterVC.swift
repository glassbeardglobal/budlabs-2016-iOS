//
//  RegisterVC.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/17/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    let http = HTTP()
    let barley:String = "http://barleynet.herokuapp.com/api/users"
    var agro = false;
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var agroButton: UIButton!
    @IBOutlet weak var growButton: UIButton!
    @IBAction func agronomistButton(_ sender: UIButton) {
        agro = true;
        agroButton.tintColor = UIColor.red
        growButton.tintColor = UIColor.init(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func growerButton(_ sender: UIButton) {
        agro = false;
        agroButton.tintColor = UIColor.init(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        growButton.tintColor = UIColor.red
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        if let e = emailTextField.text, let n = nameTextField.text, let p = passwordTextField.text {
            registerPostRequest(withURL: barley, andPost: "email=\(e)&name=\(n)&password=\(p)&agronomist=\(agro)")
        }
//        getRequest(withURL: barley)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerPostRequest(withURL url:String, andPost post:String) {
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                let user = json?["user"] as? [String: AnyObject]
                if let id = user?["_id"] as? String {
                    UserDefaults.standard.set(id, forKey: "id")
                    print(UserDefaults.standard.object(forKey: "id") as! String)
                }
            } catch {
                print("JSON serialization failed")
            }
        }
        task.resume()
    }
    
    func getRequest(withURL url:String) {
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
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                print(json)
            } catch {
                print("JSON serialization failed")
            }
        }
        task.resume()
    }
    
    
}
