//
//  LogTableView.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/18/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit

class LogTableVC: UITableViewController{

    var barley:String = "http://barleynet.herokuapp.com/api/logs/\(UserDefaults.standard.object(forKey: "id") as! String)"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "test"
        getRequest(withURL: barley)
        return cell
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
