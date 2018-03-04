//
//  ViewController.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/17/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let barley:String = "http://barleynet.herokuapp.com/api/test"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequest(withURL: barley)
        postRequest(withURL: barley, andPost: "test=You Bitch")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func postRequest(withURL url:String, andPost post:String) {
        let myURL = URL(string: url)
        var request = URLRequest(url: myURL!)
        request.httpMethod = "POST"
        let postString = post
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                print("postRequest:")
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                print(json)
            } catch {
                print("JSON serialization failed")
            }
        }
        task.resume()
    }
}

