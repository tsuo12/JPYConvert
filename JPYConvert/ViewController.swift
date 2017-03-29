//
//  ViewController.swift
//  JPYConvert
//
//  Created by chuck on 2017/3/26.
//  Copyright © 2017年 chuck. All rights reserved.
//

import UIKit
//import SettingDataManager

var gSettingDataManager = SettingDataManager()

class ViewController: UIViewController,XMLParserDelegate,UITextFieldDelegate {
    
   
    @IBOutlet var TWDLabel: UILabel! //台幣
    
    @IBOutlet var taxRateField: UITextField! //稅率欄位
   

    @IBOutlet var exchangeRateField: UITextField! //匯率欄位
    
    @IBOutlet var JPYField: UITextField! //日圓輸入欄位
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        gSettingDataManager.parserDelegate = self
        JPYField.delegate = self
        
        taxRateField.text = gSettingDataManager.getTaxRate()
        exchangeRateField.text = gSettingDataManager.getExchangeRate()
        
        
        taxRateField.keyboardType = .numberPad
        JPYField.keyboardType = .numberPad
        exchangeRateField.keyboardType = .decimalPad
        
        
        
        //gSettingDataManager.getExchangeRateFromNet()
        //countTWD()

        taxRateField.addTarget(self, action: #selector(taxRateFieldEditEnd(textField:)), for: .editingDidEnd)
        
        exchangeRateField.addTarget(self, action: #selector(exchangeRateFieldEditEnd(textField:)), for: .editingDidEnd)
        
        JPYField.addTarget(self, action: #selector(JPYFieldDidChange(textField:)), for: .editingChanged)
    }
    
    
    
    func countTWD(){
        
        //if(JPYField.text == nil) {return}
        //print(JPYField.text)
        var dTWD = Double(TWDLabel.text!)
        let dJPY = Double(JPYField.text!)
        let dTaxRate = Double(taxRateField.text!)
        let dExchangeRate = Double(exchangeRateField.text!)
        
        //dJPY = 0
        TWDLabel.text = "0"
        if(dTWD == nil)          {return}
        if(dJPY == nil)          {return}
        if(dTaxRate == nil)      {return}
        if(dExchangeRate == nil) {return}
        
        let totalJPY = dJPY! * (1+dTaxRate!/100.0)
        
        
        dTWD = totalJPY * dExchangeRate!
        
        print("dTWD= \(dTWD!)")
        
        // 無條件捨去小數點第一位
        //let iTWD = Int(dTWD!*10)
        //TWDLabel.text = String(Double(iTWD)/10)

        // 四捨五入取小數點第一位
        TWDLabel.text = String(format:"%.1f", dTWD!)

        
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {// became first responder
//        
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
    
    enum CompassPoint: String {
        case north="test", south, east, west
    }
    
    func taxRateFieldEditEnd(textField: UITextField) {
        //print("taxRateField edit end")
        gSettingDataManager.saveData(key: constStrTaxRate, value:textField.text!)
        
        //gSettingDataManager.saveData(key: CompassPoint.north.rawValue, value:textField.text!)
        
        
    }

    func exchangeRateFieldEditEnd(textField: UITextField) {
        print("exchangeRate edit end")
        gSettingDataManager.saveData(key: constStrExchangeRate, value:exchangeRateField.text!)
        

        
    }

    
    func JPYFieldDidChange(textField: UITextField) {
        //print("日圓 \(textField.text)")
        self.countTWD()
    }
    

    //text是改變前的所以不能在這計算
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        
        //print("length= \(range.length)")
        //print("location= \(range.location)")

        if(range.location >= 7) {
            return false
        }
        else{
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String){
        //print("---foundCharacters---------------")
        //print("foundCharacters:\(string) ")
        
        DispatchQueue.main.async {
            self.exchangeRateField.text = string
        }
        print("日圓匯率: \(string) ")
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        //print("---didEndElement---------------")
        
        
    }
    
    
    //    func parser(_ parser: XMLParser, foundCharacters string: String){
    //        print("-->\(string) ")
    //
    //    }
    
    func parserDidEndDocument(_ parser: XMLParser){
        //print("parserDidEndDocument ")
        
    }



}

