//
//  DeliverySummaryViewController.swift
//  DeliverApp
//
//  Created by Admin on 7/20/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class DeliverySummaryViewController: UIViewController {
    
    var userId:String = ""
    
    
    @IBOutlet weak var deliveryOptionSelectedLabel: UILabel!
    
    @IBOutlet weak var pickUpDate: UILabel!
    
    @IBOutlet weak var pickUpTime: UILabel!
    
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var stateGstLabel: UILabel!
    
    @IBOutlet weak var centralGstLabel: UILabel!
    
    
    @IBOutlet weak var grandTotalCost: UILabel!
    
    
    var Weight:String = ""
    var price :Double = 0.0
    var currentDate:String = ""
    
    var deliveryDate:String = ""
    var deliveryTime:String = ""
    var papersOrParcels:String = ""
    
    
    var getPickUpIDFromDeliveryMainVc:String = ""
    
    var getDeliveryIDFromDeliveryMainVc:String = ""
    
    var deliveryAddress = UITextView()
    
    
    var sGST:Double = 0.0
    var cGST :Double = 0.0
    var GrandtotalAmount:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    userId = UserDefaults.standard.value(forKey: "user_id") as! String
    print("delivery summary userId is",userId)
    
    setNavItem()
        
        self.deliveryOptionSelectedLabel.text = papersOrParcels
        print("delivery option selected User",papersOrParcels)
        
        self.weightLabel.text = String(format: "%@GMS", Weight)
        print("weightSelectedUser",Weight)
        self.priceLabel.text = String(price)
        print("priceSelectedUser",price)
    
     //Delivery Date printing
        self.pickUpDate.text = deliveryDate
        print("deliveryDate is",deliveryDate)
    
     // current Date printing
        self.pickUpDate.text = currentDate
        print("current date is",currentDate)
        
        self.pickUpTime.text = deliveryTime
        print("delivery time is",deliveryTime)
    
    
        self.addressTextView.text! = self.deliveryAddress.text!
        print("delivery Address is",self.deliveryAddress.text!)
    
    
     print("****** pickupID is ****** ", getPickUpIDFromDeliveryMainVc)
     print("****** deliveryID is ******",getDeliveryIDFromDeliveryMainVc)
    
    
    
    sGST = price*0.06
    cGST = price*0.06
    GrandtotalAmount = price + sGST + cGST
    
    self.stateGstLabel.text = String(format: "%..2f", sGST)
    print("state GST is ",sGST)
    self.centralGstLabel.text = String(format: "%..2f", cGST)
    print("central GST is ",cGST)
    
    self.priceLabel.text = "₹" + String(format:"%..2f", price)
    
    self.grandTotalCost.text = "₹" + String(format: "%..2f", GrandtotalAmount)
    print("grand total Amount is ",GrandtotalAmount)
    
    }
    
func setNavItem(){
        
        self.title = "Delivery Summary Details"
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

    @IBAction func processButton(_ sender: Any) {
        
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/summary")!, params: ["user_id":userId, "parcel_type" : papersOrParcels , "delivery_date" :deliveryDate,"delivery_time" : deliveryTime , "delivery_address" :deliveryAddress.text! ,"weight" :Weight,"price":price,"SGST":sGST,"CGST":cGST,"total":GrandtotalAmount,"pickup_id":getPickUpIDFromDeliveryMainVc,"delivery_id":getDeliveryIDFromDeliveryMainVc], viewcontroller: self, finish:finishPost)

    }
    
func finishPost(message:String, data:Data?)->Void{
        
        if let jsonData = data
        {
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                
                let getSummaryID = json["summary_id"] as! String
                print("get summaryID is",getSummaryID)
                
                
             
                if String(describing: json["success"]!) == "true" {
               // if json["success"] as? String ?? "" == "success" {
                  print("delivery summary Report")
                    // UserDefaults.standard.set(updateUserId, forKey: "user_id")
                    //mobile text pass
                    
//                    var double = 2.225
//                    var stringFromDouble = "\(double)"
//
                    
                    let deliverySummarry = storyboard?.instantiateViewController(withIdentifier: "DeliveryPaymentViewController") as! DeliveryPaymentTypeViewController
                        deliverySummarry.totalAmount = GrandtotalAmount
                        deliverySummarry.summaryId = getSummaryID

                    let nav = UINavigationController(rootViewController: deliverySummarry)
                    
                    DispatchQueue.main.async {
                        
                        self.present(nav, animated: true, completion: nil)
                    }
                    
                }else{
                    
                    
                }
                
            }else{
                
               //showAlert(msg:"something went wrong")
            }
        }
    }
    
    
    
}
