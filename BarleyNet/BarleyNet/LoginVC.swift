//
//  LoginVC.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/17/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    var barley:String = "http://barleynet.herokuapp.com/api/users/"

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButton(_ sender: UIButton) {
        if let id = UserDefaults.standard.object(forKey: "id") as? String {
            var barley:String = "http://barleynet.herokuapp.com/api/users/"
            barley = "\(barley)\(id)"
            print(barley)
            loginGetRequest(withURL: barley)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginGetRequest(withURL url:String) {
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

    
    func loginPostRequest(withURL url:String, andPost post:String) {
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
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
                print(json)
            } catch {
                print("JSON serialization failed")
            }
        }
        task.resume()
    }
    
    
}


