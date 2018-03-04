//
//  AddFieldVC.swift
//  BarleyNet
//
//  Created by Rahul Surti on 9/18/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit

class AddFieldVC: UIViewController {
    let barley:String = "http://barleynet.herokuapp.com/api/fields/"

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var entityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var coordinatesTextField: UITextField!
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if let id = UserDefaults.standard.object(forKey: "id"), let n = nameTextField.text, let e = entityTextField.text, let p = phoneTextField.text, let c = coordinatesTextField.text {
            let post = "contract=\(UserDefaults.standard.object(forKey: "currentContractID") as! String)&name=\(n)&entity=\(e)&phone=\(p)&address=\(c)"
            addFieldPostRequest(withURL: barley, andPost: post)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addFieldPostRequest(withURL url:String, andPost post:String) {
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
