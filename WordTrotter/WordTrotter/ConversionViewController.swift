//
//  ConversionViewController.swift
//  WordTrotter
//
//  Created by FARIT GATIATULLIN on 10/06/2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celciusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    var fahernheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelciusLabel()
        }
    }
    
    var celciusValue: Measurement<UnitTemperature>? {
        if fahernheitValue != nil {
            return fahernheitValue?.converted(to: .celsius)
        } else {
            return nil
        }
    }
    var appeared = 0
    
    @IBAction func fahrenheitFieldChanged(textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahernheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahernheitValue = nil
        }
    }
    @IBAction func dismissKeyboard(_ sender:UITapGestureRecognizer) {
        textField.resignFirstResponder()
}
    
    func updateCelciusLabel() {
        if let celciusValue = celciusValue {
            celciusLabel.text = numberFormatter.string(from: NSNumber(value: celciusValue.value))
        } else {
            celciusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
        updateCelciusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        First option — rark mode, uncomment (if) below to enable
        let myBackgroundColor = UIColor(red: 0.18, green: 0.21, blue: 0.25, alpha: 1.00)
        super.viewWillAppear(false)
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        print("Current hour is \(hour)")

        if !(8 ... 23 ~= hour) {
        self.view.backgroundColor = myBackgroundColor
    }
//              Second option — radndom color
        func getRandomColor() -> UIColor{

            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())
            
            return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
        
//        self.view.backgroundColor = getRandomColor()
    }
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
//        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        let decimalSeparatorAsString: String = decimalSeparator
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        var allowedCharSet = CharacterSet(charactersIn: "0123456789")
        allowedCharSet.insert(charactersIn: decimalSeparatorAsString)
        let charSetFromInput = NSCharacterSet(charactersIn: string)
        let checkForInvalidCharacters = allowedCharSet.isSuperset(of: charSetFromInput as CharacterSet)
        if checkForInvalidCharacters != true {
            return false
        } else
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
    
    var allowed = NSCharacterSet()
   
    
    
}
