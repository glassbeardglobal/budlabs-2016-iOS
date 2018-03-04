//
//  ContractTableVC.swift
//  
//
//  Created by Rahul Surti on 9/18/16.
//
//

import UIKit

class ContractTableVC: UITableViewController {
    let barley:String = "http://barleynet.herokuapp.com/api/contracts/"
    let id = UserDefaults.standard.object(forKey: "id") as! String
    var contracts:[String] = []
    var contractids:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.refreshControl?.addTarget(self, action: "refreshTable:", for: .valueChanged)
//        self.tableView.addSubview(refreshControl!)
        if(id != nil) {
            contractGetRequest(withURL: "\(barley)?id=\(id)")
        }
    }
    
    func refreshTable() {
        // Code to refresh table view
        contractGetRequest(withURL: "\(barley)?id=\(id)")
        self.refreshControl?.endRefreshing()

    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contracts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contractCell", for: indexPath)
        cell.textLabel?.text = self.contracts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(contracts[indexPath.row], forKey: "currentContractName")
        UserDefaults.standard.set(contractids[indexPath.row], forKey: "currentContractID")
        self.tabBarController?.selectedIndex = 1
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func contractGetRequest(withURL url:String) {
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
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                if let jsonArray = json as [AnyObject]! {
                    self.contracts.removeAll()
                    self.contractids.removeAll()
                    for object in jsonArray {
                        if let contract = object as? [String: AnyObject] {
                            if let c = contract["name"] as? String {
                                self.contracts.append(c)
                            }
                            if let i = contract["_id"] as? String {
                                self.contractids.append(i)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print(json)
                }
        
            } catch {
                print("JSON serialization failed")
            }
        }
        task.resume()
    }
}
