//
//  TermsAndConditionsViewController.swift
//  PIK N DROP
//
//  Created by Admin on 12/19/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setNavItem()
        
    }
    
func setNavItem(){
        
        self.title = "Terms And Conditions"
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissVC))
        //above line one we used stop button
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        
        
        // setting the color navigation item in top bellow line code
        // navigationController?.navigationBar.barTintColor = UIColor.brown
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
    }
    
@objc fileprivate func menuButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }

}
