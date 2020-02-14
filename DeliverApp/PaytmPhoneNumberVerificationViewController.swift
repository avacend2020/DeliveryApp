//
//  PaytmPhoneNumberVerificationViewController.swift
//  PIK N DROP
//
//  Created by Admin on 1/22/20.
//  Copyright © 2020 User 2. All rights reserved.
//

import UIKit

class PaytmPhoneNumberVerificationViewController: UIViewController {
    
    @IBOutlet weak var mobileTxtField: UITextField!
    
    var getPickUpMobileNumber:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
        getPickUpMobileNumber = UserDefaults.standard.value(forKey: "user_mobile") as! String
        print("get user mobile ",getPickUpMobileNumber)
        
        mobileTxtField.text = "+" + getPickUpMobileNumber
        
    
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
   }


}
