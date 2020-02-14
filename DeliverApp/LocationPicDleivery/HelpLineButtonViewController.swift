//
//  HelpLineButtonViewController.swift
//  PIK N DROP
//
//  Created by Admin on 12/30/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class HelpLineButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
@IBAction func okGotItBtnAction(_ sender: Any) {
    
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
