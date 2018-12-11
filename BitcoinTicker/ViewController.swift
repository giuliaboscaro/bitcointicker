//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Giulia Boscaro on 10/12/2018.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["Pick a coin" ,"AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let currencyLocationArray = ["" ,"en_AU", "pt_BR", "en_CA", "zh_CN", "ca_ES", "en_GB", "en_HK", "id_ID", "he_IL", "hi_IN", "ja_JP", "es_MX", "nb_NO", "en_NZ", "pl_PL", "ro_RO", "ce_RU", "sv_SE", "en_SG", "en_US", "en_ZA"]

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        
        if row == 0 {
            bitcoinPriceLabel.text = "Pick a coin"
        }
        else {
            getBitCurrency(url: finalURL, location: currencyLocationArray[row])
        }
        
    }

    
    func getBitCurrency(url: String, location: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess")
                    let bitJSON: JSON = JSON(response.result.value!)
                    self.updateCurrency(json: bitJSON, location: location)
                }
                else {
                    print("Error: \(response.result.error!)")
                    self.bitcoinPriceLabel.text = "Connection problems"
                }
        }
    }
    
    
    func updateCurrency(json: JSON, location: String) {
        
        if let bitcoinResult = json["last"].double {
            bitcoinPriceLabel.text = formatCurrency(returnedValue: bitcoinResult, location: location)
        }
        else {
            bitcoinPriceLabel.text = "Currency Unavailable"
        }
    }
    

    func formatCurrency(returnedValue: Double, location: String) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: location)
        let valueFormated = currencyFormatter.string(from: NSNumber(value: returnedValue))!
        return valueFormated
    }
    

}

