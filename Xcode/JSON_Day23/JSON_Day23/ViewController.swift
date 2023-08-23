//
//  ViewController.swift
//  JSON_Day23
//
//  Created by Imam MohammadUvesh on 09/12/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var arrData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //  calledCountryGetAPI()
       // calledLocalJson()
      
        jsonAlamofire()
      //  jsonAfWithoutSerialization()
      
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        APIHelper.shareInstance.capture { value in
//            print(value)
        }
        
        APIHelper.shareInstance.jsonUrlCalling { arrResponse in
//            print(arrResponse)
        }
        
        APIHelper.shareInstance.jsonLocalCalling { jsonArray in
            for country in jsonArray{
                
                var dict: [String: Any] = [
                    "name": country["name"] as? String ?? "No name",
                    "capital": country["capital"] as? String ?? "No capital",
                    "flag": country["flag"] as? String ?? "No flag",
                    "alpha2Code": country["alpha2Code"] as? String ?? "No alpha2Code",
                    "alpha3Code": country["alpha3Code"] as? String ?? "No alpha3Code",
                    "region": country["region"] as? String ?? "No region"
                ]
                
                if let currencies = country["currencies"] as? [[String: String]]{
                    if let currency = currencies.first{
                        dict["currency"] = currency
                        //                            dict["currencyName"] = currency["name"] ?? "No currency name"
                        //                            print(currency["name"])
                    }
                }
                
                //altSpellings
                if let altSpellings = country["altSpellings"] as? [String]{
                    if let altSpelling = altSpellings.first{
                        dict["altSpelling"] = altSpelling
                    }
                }
                
                //borders
                if let borders = country["borders"] as? [String]{
                    dict["borders"] = borders
                }
                
                //languages
                var arrLangauges = [[String: String]]()
                
                if let languages = country["languages"] as? [[String: String]]{
                    for language in languages {
                        
                        let languageDict: [String: String] = [
                            "iso639_1": language["iso639_1"] ?? "No iso639_1",
                            "name": language["name"] ?? "No name"
                        ]
                        
                        arrLangauges.append(languageDict)
                    }
                    print(arrLangauges)
                    dict["languages"] = arrLangauges
                }
                
                self.arrData.append(dict)
            }
            
            self.tableView.reloadData()
        }
        
    }
}

//MARK: Table View DataSource
extension ViewController: UITableViewDataSource
{
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
        cell.textLabel?.text = country["name"] as? String ?? ""
        cell.detailTextLabel?.text = (country["capital"] as? String ?? "") + " " + (country["currencyName"] as? String ?? "")
        return cell
    }
}

//MARK: Table View Delegate
extension ViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableDataViewController") as? TableDataViewController
        {
            //MARK: Passing Dictionary to Another View Controller
            tableDataViewController.arrDict = arrData[indexPath.row]
            self.navigationController?.pushViewController(tableDataViewController, animated: true)
        }
        
        //print(arrData[indexPath.row])
    }
}

 //MARK: Get JSON DATA USING ALAMOFIRE LIBRARY
extension ViewController
{
    func jsonAlamofire()
    {
        AF.request(APIHelper.shareInstance.baseURL).response { response in
            switch response.result
            {
            case .success(let data):
                guard let data = data else {return}
                do
                {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data)
                    print(jsonResponse)
                } catch
                {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func jsonAfWithoutSerialization()
    {
        AF.request(APIHelper.shareInstance.baseURL).responseJSON { response in
            switch response.result
            {
            case .success(let jsonResponse):
            print(jsonResponse)
            case .failure(let error):
            print(error)
            }
        }
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


////MARK: JSON CALLING
//func jsonLocalCalling()
//{
//   //MARK: First Access the local JSON file using bundel
//    guard let countryJson = Bundle.main.url(forResource: "CountryJson", withExtension: "json"), let data = try? Data(contentsOf: countryJson)
//    else
//    {
//        return
//    }
//    do {
//        let jsonResponse = try JSONSerialization.jsonObject(with: data)
//        if let jsonArray = jsonResponse as? [[String:AnyObject]]
//        {
//            for country in jsonArray
//            {
//                var dict: [String:String] = [
//                    "region": country["region"] as? String ?? "No Region",
//                    "alpha2Code":country["alpha2Code"] as? String ?? "No Alpha2Code",
//                    "alpha3Code":country["alpha3Code"] as? String ?? "No Alpha3Code",
//                ]
//
//                if let currencyies = country["currencies"] as? [[String:String]]
//                {
//                    if let currency = currencyies.first
//                    {
//                        dict["currencyName"] = currency["name"] ?? "No Currency Name"
//                        dict["currencyCode"] = currency["code"] ?? "No Currency Code"
//                        dict["currencySymbol"] = currency["symbol"] ?? "No Currency Symbol"
////                          print(currency["name"])
//                    }
//                }
//
//                self.arrData.append(dict)
//            }
//
//            self.tableView.reloadData()
//                 print(self.arrData)
//        }
//    } catch {
//        print(error.localizedDescription)
//    }
//
//}


////MARK: JSON Calling from API
//func jsonUrlCalling()
//{
//    guard let url = URL(string: "http://api.countrylayer.com/v2/all?access_key=81f78bbc28e97a49929a609f358e7c98") else
//    {
//        return
//    }
//
//    URLSession.shared.dataTask(with: url)
//    {
//        data,response,error in guard let data = data else
//        {
//            return
//
//        }
//        do { let jsonResponse = try JSONSerialization.jsonObject(with: data)
//            if let jsonArray = jsonResponse as? [[String:AnyObject]]
//            {
//                for country in jsonArray
//                {
//                    let dict:[String:String] = [
//                        "name": country["name"] as? String ?? "No Name",
//                        "capital": country["capital"] as? String ?? "No Capital"
//                    ]
//
//                    self.arrData.append(dict)
//                }
//
//                DispatchQueue.main.async
//                {
//                    self.tableView.reloadData()
//                }
//                print(self.arrData)
//            }
//        }
//        catch
//        {
//            print(error.localizedDescription)
//        }
//    }.resume()
//}
