//
//  SettingDataManager.swift
//  JPYConvert
//
//  Created by chuck on 2017/3/26.
//  Copyright © 2017年 chuck. All rights reserved.
//

import Foundation

let constStrTaxRate = "taxRate"
let constStrExchangeRate = "exchangeRate"


class SettingDataManager{
    
    //var taxRate = "0"
    //var exchangeRate = "0.27"
    
    var parserDelegate: XMLParserDelegate?
    
    func saveData(key:String, value:String){
        if(value == "" || value == " "){
            return
        }
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    func getData(_ key:String)->String?{
        //let userDefault = UserDefaults.standard
        let userDefault = UserDefaults.standard
        let value =  userDefault.string(forKey: key)
        return value
    }
    
    
    func getTaxRate()->String{
        let rate = getData(constStrTaxRate)
        if(rate == nil){
            return "0"
        }
        else{
            return rate!
        }
    }
    
    func getExchangeRate()->String{
        let rate = getData(constStrExchangeRate)
        
        if(rate == nil){
            getExchangeRateFromNet()
            return "0.27"
        }
        else{
            return rate!
        }

    }

    
    
    func getExchangeRateFromNet(){
        
        let urlStr = "http://www.webservicex.net/CurrencyConvertor.asmx/ConversionRate?FromCurrency=JPY&ToCurrency=TWD"
        
        let url = URL(string: urlStr)
        
        let urlRequest = URLRequest(url: url!, cachePolicy:.returnCacheDataElseLoad,
                                    timeoutInterval: 30)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data:Data?, response:URLResponse?, err:Error?) -> Void in
            if let data = data,
                let html = String(data: data, encoding: String.Encoding.utf8) {
                               let parser = XMLParser(data: data)
                
                print(html)
                parser.delegate = self.parserDelegate
                
                let success:Bool = parser.parse()
            
                if success {
                    //print("parse success!")
                    
                } else {
                    print("parse failure!")
                }

            }
        }
        task.resume()
        
    }
    
}
