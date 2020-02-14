//
//  DeliveryOrderPlacedViewController.swift
//  DeliverApp
//
//  Created by Admin on 8/17/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class DeliveryOrderPlacedViewController: UIViewController {
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    
    @IBOutlet weak var orderTotalAmountLabel: UILabel!
    
    
    @IBOutlet weak var orderDate: UILabel! 
    
    
    @IBOutlet weak var orderTime: UILabel!
    
    

    var orderNumber:String = ""
    var orderTotalAmount:Double = 0.0
    var orderDateday:String = ""
    var orderTimeday:String = ""
    
  
    
override func viewDidLoad() {
        super.viewDidLoad()


    scheduleNotification(title:"You are placed order Successfully", subTitle:"Your Order Number is " + String(orderNumber), body:"Your Order Amount is " + String(orderTotalAmount), timeDelayinSec: 60.0)
//      let from = AppConstants.pickupLocation?.address ?? ""
//           let to = AppConstants.deliveryLocation?.address ?? ""
//           let type = AppConstants.Documents?.CatName ?? ""
           let notificationMsg = "You are placed order Successfully ,Your Order Number is " + String(orderNumber) + "Your Order Amount is " + String(orderTotalAmount)
        AppConstants.notifications.append(notificationMsg)
    
      //addNavigationBarButton(imageName: "backWhite", direction: .left)
    
  }
    
override func viewWillAppear(_ animated: Bool) {
          print(orderNumber)
          print(orderTotalAmount)
          print(orderDateday)
          print(orderTimeday)
          
          self.orderNumberLabel.text = orderNumber
          
         // self.orderTotalAmountLabel.text =  "₹" + String(format:orderTotalAmount)
          self.orderTotalAmountLabel.text = String(orderTotalAmount)
          self.orderDate.text = orderDateday
          self.orderTime.text = orderTimeday
    }
    
@IBAction func backBtnAction(_ sender: Any) {
        
    self.navigationController?.popViewController(animated: true)
   
  }
    
    
enum direction {
    
        case right
        case left
    }
    
}
