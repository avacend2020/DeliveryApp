//
//  OrderDetailViewController.swift
//  PIK N DROP
//
//  Created by Admin on 10/4/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    
    var userId:String = ""
    
    
    var orderIdGettingOrderDetail:String = ""
    
    
    
    var orderDate:String = ""
    
    var deliveryTime:String = ""
    
    var orderStatus:String = ""
    
    
    var customerName:String = ""
    var email:String = ""
    
    
    
    //pickup Address varable declaration
    
    var pickUpName:String = ""
    var PickUpStreetAddress:String = ""
    var PickUpCity:String = ""
    var pickUpState:String = ""
    var pickUpPincode:String = ""
    var pickUpMobile:String = ""
    
   //delivery Address varable declaration
    
    var deliveryName:String = ""
    var deliveryStreetAddress:String = ""
    var deliveryCity:String = ""
    var deliveryState:String = ""
    var deliveryPincode:String = ""
    var deliveryMobile:String = ""
    
    
    var weight:String = ""
    var sGST:String = ""
    var cGST:String = ""
    var total:String = ""
    
    
    
    
    @IBOutlet weak var orderIDView1: UIView!
    
    @IBOutlet weak var orderInformationView2: UIView!
    
    
    @IBOutlet weak var accountInformationView3: UIView!
    
    @IBOutlet weak var pickUpAddressView4: UIView!
    
    
    
    @IBOutlet weak var deliveryAddressView5: UIView!
    
    
    @IBOutlet weak var weightView6: UIView!
    
    

    
    
    
    
    
    

    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    
    
    
    
    
    
    @IBOutlet weak var customerNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    
    @IBOutlet weak var pickUpNameLabel: UILabel!
    
    @IBOutlet weak var pickUpStreetLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var pincodeLabel: UILabel!
    
    @IBOutlet weak var mobileLabel: UILabel!
    
    
    @IBOutlet weak var deliveryNameLabel: UILabel!
    
    @IBOutlet weak var deliveryStreetLabel: UILabel!
    
    @IBOutlet weak var deliveryCityLabel: UILabel!
    
    @IBOutlet weak var deliveryStateLabel: UILabel!
    
    @IBOutlet weak var deliveryPincodeLabel: UILabel!
    
    
    @IBOutlet weak var deliveryMobileLabel: UILabel!
    
    
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var stateGSTLabel: UILabel!
    
    @IBOutlet weak var centralGSTLabel: UILabel!
    
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addNavigationBarButton(imageName: "backWhite", direction: .left)
      
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        print("orderDetailUserID is ",userId)
        
        print("****** orderID is ******",orderIdGettingOrderDetail)

        orderIDLabel.text = orderIdGettingOrderDetail
        
        
//        orderIDView1.layer.shadowColor = UIColor.brown.cgColor
//        orderIDView1.layer.shadowOpacity = 0.3
//        orderIDView1.layer.shadowOffset = CGSize(width: 1, height: 1)
//        orderIDView1.layer.shadowRadius = 5
//        orderIDView1.layer.masksToBounds = false
//        orderIDView1.layer.cornerRadius = 8
//        orderIDView1.layer.masksToBounds = true
//        self.orderIDView1.layer.borderWidth = 1
//        self.orderIDView1.layer.borderColor = UIColor(red:148/255, green:93/255, blue:94/255, alpha: 1).cgColor
        
    
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/orderdetails")!, params: ["user_id" : userId,"order_id":orderIdGettingOrderDetail], viewcontroller: self, finish:finishPost)
        
        
    }
    
func addNavigationBarButton(imageName:String,direction:direction){
        
        self.title = "Order Details"
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
        self.navigationController!.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        var image = UIImage(named:imageName)
        image = image?.withRenderingMode(.alwaysOriginal)
        switch direction {
        case .left:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(goBack))
        case .right:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(goBack))
            
        }
    }
    
@objc func goBack() {
         navigationController?.popViewController(animated: true)
       // self.dismiss(animated: true, completion: nil)
        
    }
    
enum direction {
        case right
        case left
    }
    
// func setupNavigation() {
//
//        self.title = "Order Details"
//
////        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .done, target: self, action: #selector(menuAction))
//
//
//
//    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
//        self.navigationController!.navigationBar.tintColor = .white
//        self.navigationController!.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.white
//        ]
//
//
//    }
//@objc func menuAction(){
//
// }
    
func finishPost(message:String,data:Data?)->Void{
        
        if let jsonData = data {
            
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] {  // as? data type
                
                print("order Details is" ,json)
                
                
                let deliveryDate = json["delivery_date"] as! String
               // print(deliveryDate)
                orderDate = deliveryDate
                print(orderDate)
                
                DispatchQueue.main.async {
                    self.orderDateLabel.text = self.orderDate
                }
                
                
                
                let deliveryTimeFromJson = json["delivery_time"] as! String
                // print(deliveryTimeFromJson)
                deliveryTime = deliveryTimeFromJson
                print(deliveryTime)

                DispatchQueue.main.async {

                    self.deliveryTimeLabel.text = self.deliveryTime
                }

                
                
                
               
                
                let orderStatusIdentity = json["order_status"] as! String
               //print(orderStatus)
                orderStatus = orderStatusIdentity
                print(orderStatus)
                
                DispatchQueue.main.async {
                    self.orderStatusLabel.text = self.orderStatus
                }
               
                
                
                
                
                let customerReceivingName = json["delivery_name"] as! String
                 print(customerName)
                customerName = customerReceivingName
                 print(customerName)
                
                DispatchQueue.main.async {
                    
                    self.customerNameLabel.text = self.customerName
                }
                
                
                
                let customerEmail = json["user_email"] as! String
                print(email)
                email = customerEmail
                print(email)
                
                DispatchQueue.main.async {
                    
                    self.emailLabel.text = self.email
                    
                }
                
                
                //PickUp Address Display in Label
                
                let pickUpNameFromJson = json["pick_name"] as! String
                //print(pickUpNameFromJson)
                pickUpName = pickUpNameFromJson
                print(pickUpName)
                
                DispatchQueue.main.async {
                    self.pickUpNameLabel.text = self.pickUpName
                }
                
                
                let pickUpStreetFromJson = json["pick_street_address"] as! String
               //print(pickUpStreetFromJson)
                PickUpStreetAddress = pickUpStreetFromJson
                print(PickUpStreetAddress)
                DispatchQueue.main.async {
                    
                    self.pickUpStreetLabel.text = self.PickUpStreetAddress
                }
               
                
                let cityFromJson = json["pick_city"] as! String
                //print(cityFromJson)
                PickUpCity = cityFromJson
                print("******PickUpCity******",PickUpCity)
                
                DispatchQueue.main.async {
                    self.cityLabel.text = self.PickUpCity
                }
                
                
                let stateFromJson = json["pick_state"] as! String
               //print(stateFromJson)
                pickUpState = stateFromJson
                print(pickUpState)
                DispatchQueue.main.async {
                    
                    self.stateLabel.text = self.pickUpState
                }
                
                
                let pincodeFromJson = json["pick_picode"] as! String
               // print(pincodeFromJson)
                pickUpPincode = pincodeFromJson
                print(pickUpPincode)
                DispatchQueue.main.async {
                    self.pincodeLabel.text = self.pickUpPincode
                }
               
                
                let mobileFromJson = json["pick_mobile"] as! String
               // print(mobileFromJson)
                pickUpMobile = mobileFromJson
                print(pickUpMobile)
                DispatchQueue.main.async {
                    
                    self.mobileLabel.text = self.pickUpMobile
                    
                }
               
                
                
                
                //Delivery Address Display in Label
                
                let deliveryNameFromJson = json["delivery_name"] as! String
                //print(deliveryNameFromJson)
                deliveryName = deliveryNameFromJson
                print(deliveryName)
                
                DispatchQueue.main.async {
                    
                    self.deliveryNameLabel.text = self.deliveryName
                }
                
                
                let deliveryStreetFromJson = json["delivery_street_address"] as! String
                //print(deliveryStreetFromJson)
                deliveryStreetAddress = deliveryStreetFromJson
                print(deliveryStreetAddress)
                
                DispatchQueue.main.async {
                    
                    self.deliveryStreetLabel.text = self.deliveryStreetAddress
                    
                }
                
                
                let deliveryCityJson = json["delivery_city"] as! String
                //print(deliveryCityJson)
                deliveryCity = deliveryCityJson
                print(deliveryCity)
                DispatchQueue.main.async {
                    self.deliveryCityLabel.text = self.deliveryCity
                }
                
                
                let deliveryStateFromJson = json["delivery_state"] as! String
                //print(deliveryStateFromJson)
                deliveryState = deliveryStateFromJson
                print(deliveryState)
                
                DispatchQueue.main.async {
                    self.deliveryStateLabel.text = self.deliveryState
                    
                }
            
                
                let deliveryPincodeFromJson = json["delivery_picode"] as! String
                // print(deliveryPincodeFromJson)
                deliveryPincode = deliveryPincodeFromJson
                print(deliveryPincode)
                DispatchQueue.main.async {
                    self.deliveryPincodeLabel.text = self.deliveryPincode
                }
               
                
                let deliveryMobileFromJson = json["delivery_mobile"] as! String
                //print(deliveryMobileFromJson)
                deliveryMobile = deliveryMobileFromJson
                print(deliveryMobile)
                DispatchQueue.main.async {
                    
                    self.deliveryMobileLabel.text = self.deliveryMobile
                    
                }
                
                
                let weightFromJson = json["weight"] as! String
                print(weightFromJson)
                weight = weightFromJson
                print(weight)
                
                DispatchQueue.main.async {
                    
                    self.weightLabel.text = String(format:"%@GMS",self.weight)
                }
              // String(format: "%@GMS", Weight)
                
                let sGSTFromJson = json["SGST"] as! String
                print(sGSTFromJson)
                sGST = sGSTFromJson
                print(sGST)
                
                DispatchQueue.main.async {
                    self.stateGSTLabel.text = self.sGST
                }
               
                
                
                
                let cGSTFromJson = json["CGST"] as! String
                print(cGSTFromJson)
                cGST = cGSTFromJson
                print(cGST)
                
                DispatchQueue.main.async {
                    
                    self.centralGSTLabel.text = self.cGST
                }
               
                
                
                let totalAmountFromJson = json["price"] as! String
                print(totalAmountFromJson)
                total = totalAmountFromJson
                print(total)
                
                DispatchQueue.main.async {
                    
                    self.totalAmountLabel.text = "₹" + String(format: self.total)
                }
                
            }
        }
    }
//override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        // Hide the Navigation Bar
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//
//    }
    
 
@IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    
  }
    
    

}

