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
        getRequest(withURL: barley);
        postRequest(withURL: barley, andPost:"test=You Bitch");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getJSON(withString s:String) {
        let url = NSURL(string: s)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    if let message = jsonResult["message"] as? String {
                        print(message)
                    } else {
                        print("nil value")
                    }
                } catch {
                    print("JSON serialization failed")
                }
            }
        }
        task.resume()
    }
    
    func getRequest(withURL url:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            if let urlContent = data {
                do {
                    print("getRequest:")
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    print(jsonResult)
                } catch {
                    print("JSON serialization failed")
                }
            }
        }
        task.resume()
    }
    
    func postRequest(withURL url:String, andPost post:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let postString = post
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            if let urlContent = data {
                do {
                    print("postRequest:")
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    print(jsonResult)
                } catch {
                    print("JSON serialization failed")
                }
            }
        }
        task.resume()
    }
}

