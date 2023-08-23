//
//  JsonDecoderViewController.swift
//  JSON_Day23
//
//  Created by Imam MohammadUvesh on 22/12/21.
//

import UIKit

//MARK: First Create Structure Model
struct jsonModel: Decodable {
    var name: String
    var capital: String
    var region: String
    var borders: [String]
    var currencies: [CurrencyModel]
    
    struct CurrencyModel: Decodable{
        var code: String?
        var symbol: String?
        var name: String?
    }
}

class JsonDecoderViewController: UIViewController {

    //MARK: Variables
    var jsonarray = [jsonModel]()
    
    //MARK: Helper Method
    override func viewDidLoad() {
        super.viewDidLoad()
        callJSON()
      //  calledLocalJson()
    }

    //MARK: JSON LOGIC for DECODER OR DECODABLE METHOD
    func callJSON()
    {
        guard let CountryjsonURL = Bundle.main.url(forResource: "CountryJson", withExtension: "json"), let data =  try? Data(contentsOf: CountryjsonURL)
        else
        {
            return
        }
        do
        {
            let jsonResponse = try JSONDecoder().decode([jsonModel].self, from: data)
            print(jsonResponse)
        }
        catch
        {
            print(error.localizedDescription)
        }

    }
    
//    func calledLocalJson(){
//        guard let countryJsonURL = Bundle.main.url(forResource: "CountryJson", withExtension: "json"), let data = try? Data(contentsOf: countryJsonURL) else { return }
//        do {
//            //CountryModel.self - Dictionary - Main starting ka response hai wo
//            //[CountryModel].self - Array
//            let jsonResponse = try JSONDecoder().decode([jsonModel].self, from: data)
//            print(jsonResponse)
//        } catch{
//            print(error.localizedDescription)
//        }
//    }
}
