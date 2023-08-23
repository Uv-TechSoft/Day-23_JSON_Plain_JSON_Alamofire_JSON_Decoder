//
//  DatailTableViewController.swift
//  JSON_Day23
//
//  Created by Imam MohammadUvesh on 15/12/21.
//

import UIKit

class DatailTableViewController: UIViewController {

   //MARK: Outlets
    @IBOutlet weak var detailedTableView: UITableView!
   //MARK: Variables
    var value: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedTableView.dataSource = self
        detailedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension DatailTableViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if let borders = value as? [String]
        {
            return borders.count
        }
        else if let currencies = value as? [String: String]
        {
            return currencies.keys.count
        }
        else if let languages = value as? [[String: String]]
        {
            return languages.count
        }else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        else
        {
            return UITableViewCell()
        }
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if let borders = value as? [String]
        {
            cell.textLabel?.text = borders[indexPath.row]
            
        }
        else if let currencies = value as? [String: String]
        {
            
            let key = Array(currencies.keys)[indexPath.row]
            if let value = currencies[key]{
                cell.textLabel?.text = "\(key) : \(value)"
        }
            
        }
        else if let languages = value as? [[String: String]]
        {
            
            if let name = languages[indexPath.row]["name"], let iso6391 = languages[indexPath.row]["iso639_1"]{
                cell.textLabel?.text = "Name : " + " " + name
                cell.detailTextLabel?.text = "iso6391 : " + " " + iso6391
        }
            
        }
        else
        {
            cell.textLabel?.text = ""
        }
        
        return cell
    }
}

