//
//  ViewController.swift
//  JsonGet
//
//  Created by Yogesh Patel on 09/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrData = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calledCountryGetAPI()
        calledLocalJson()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    ///ex   http://api.countrylayer.com/v2/all?access_key=12345678
    
    func calledCountryGetAPI(){
        guard let url = URL(string: "http://api.countrylayer.com/v2/all?access_key=yourapikeyhere") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data)
                if let jsonArray = jsonResponse as? [[String: AnyObject]]{
                   
                    for country in jsonArray{
                        
                        let dict: [String: String] = [
                            "name": country["name"] as? String ?? "No name",
                            "capital": country["capital"] as? String ?? "No capital"
                        ]
                        
                        self.arrData.append(dict)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(self.arrData)
                }
                
            } catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func calledLocalJson(){
        guard let countryJsonURL = Bundle.main.url(forResource: "CountryJson", withExtension: "json"), let data = try? Data(contentsOf: countryJsonURL) else { return }
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data)
            if let jsonArray = jsonResponse as? [[String: AnyObject]]{
               
                for country in jsonArray{
                    
                    var dict: [String: String] = [
                        "name": country["name"] as? String ?? "No name",
                        "capital": country["capital"] as? String ?? "No capital"
                    ]
                    
                    if let currencies = country["currencies"] as? [[String: String]]{
                        if let currency = currencies.first{
                            dict["currencyName"] = currency["name"] ?? "No currency name"
//                            print(currency["name"])
                        }
                    }
                    
                    self.arrData.append(dict)
                }
                
                self.tableView.reloadData()
//                print(self.arrData)
            }
        } catch{
            print(error.localizedDescription)
        }
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else
        {
            return UITableViewCell()
        }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let country = arrData[indexPath.row]
        
        cell.textLabel?.text = country["name"]
        cell.detailTextLabel?.text = (country["capital"] ?? "")  + " " + (country["currencyName"] ?? "")
        
//        cell.detailTextLabel?.text = "\(arrData[indexPath.row]["capital"]) \(arrData[indexPath.row]["currencyName"])"
        return cell
    }
}


/*
 1. "altSpellings" dict . first value get karna
 2. "flag" lai lena
 3. "currencies" - get whole dict - code, symbol, name
 4. "region"
 5. "alpha2Code"
 6. "alpha3Code"
 7. "borders" - get all
 8. "languages" - iso639_1, name
 */
