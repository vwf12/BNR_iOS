//
//  CustomTextField.swift
//  Homepwner
//
//  Created by FARIT GATIATULLIN on 03.07.2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
//        super.becomeFirstResponder()
        
        self.borderStyle = .line
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.borderStyle = .roundedRect
        return super.resignFirstResponder()
    }
    
}
