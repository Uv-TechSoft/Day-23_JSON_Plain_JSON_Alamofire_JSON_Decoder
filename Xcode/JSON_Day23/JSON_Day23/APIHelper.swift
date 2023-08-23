//
//  JSONHelper.swift
//  JSON_Day23
//
//  Created by Imam MohammadUvesh on 11/12/21.
//

import Foundation
import UIKit

class APIHelper
{
    static let shareInstance = APIHelper()
    
    //MARK: BASE URL
    let baseURL = "http://api.countrylayer.com/v2/all?access_key=81f78bbc28e97a49929a609f358e7c98"
    
    func jsonUrlCalling(completionHandler: @escaping ([[String: AnyObject]]) -> ())
    {
        guard let url = URL(string: "http://api.countrylayer.com/v2/all?access_key=81f78bbc28e97a49929a609f358e7c98") else
        {
            return
        }
        
        URLSession.shared.dataTask(with: url)
        { data, response, error in
            guard let data = data else {return}
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data)
            if let jsonArray = jsonResponse as? [[String:AnyObject]]
            {
                completionHandler(jsonArray)
            }
                }
            catch
            {
                print(error.localizedDescription)
            }
        }.resume()
    }

    func capture(completion: (Int) -> ())
    {
        print("Capture Function Called from API Helper")
        completion(11)
    }
    
    //MARK: JSON Calling form Local File
    func jsonLocalCalling(completionHandler: @escaping ([[String:AnyObject]]) -> ())
    {
        guard let jsonURL = Bundle.main.url(forResource: "CountryJson", withExtension: "json"), let data = try? Data(contentsOf: jsonURL)
        else {
            return
        }
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data)
            if let jsonArray = jsonResponse as? [[String:AnyObject]]
            {
                completionHandler(jsonArray)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}


