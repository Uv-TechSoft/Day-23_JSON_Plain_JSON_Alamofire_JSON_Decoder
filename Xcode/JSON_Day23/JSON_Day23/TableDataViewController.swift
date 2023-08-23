//
//  TableDataViewController.swift
//  JSON_Day23
//
//  Created by Imam MohammadUvesh on 11/12/21.
//

import UIKit

class TableDataViewController: UIViewController {
   
    

    //MARK: Outlets
    @IBOutlet weak var detailTableView: UITableView!
   
    //MARK: Variables
    var arrDict = [String:Any]()
    var arrDetailedData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension TableDataViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrDict.keys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else
        {
            return UITableViewCell()
        }
        let sortDict = arrDict.sorted(by: { $0.key < $1.key })
        
        let key = sortDict.map{ $0.key }[indexPath.row]
        let value = sortDict.map{ $0.value }[indexPath.row]
        
//        let key   = Array(self.arrDict.keys)[indexPath.row]
//        let value = Array(self.arrDict.values)[indexPath.row]
        cell.textLabel?.text = "\(key) : \(value)"
//      cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension TableDataViewController: UITableViewDelegate
{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MARK: Getting ALL Value or Data from The Dictionary
        let sortDict = arrDict.sorted(by: { $0.key < $1.key })
        
      //  let key = sortDict.map{ $0.key }[indexPath.row]
        let value = sortDict.map{ $0.value }[indexPath.row]
         /*
        if let _ = value as? String{//Value ki type check kar sakhate ho
            return
        }else if let borders = value as? [String]{
            print(borders)
        }else if let currencies = value as? [String: String]{
            print(currencies)
        }
        */
        print(value)
        
        //MARK: Checking If Dictionary have sub value in it or not if yes, then it will navigate to next viewcontroller otherwise it will not navigate to another screen.
        
        if let _ = value as? String{//Value ki type check kar sakhate ho
            return
        }
    
        //MARK: Navigation Logic from one to another controller
        
        if let detailedViewController = self.storyboard?.instantiateViewController(withIdentifier: "DatailTableViewController") as? DatailTableViewController
        {
            detailedViewController.value = value as AnyObject
            self.navigationController?.pushViewController(detailedViewController, animated: true)
        } 
    }
}
