
//  DeliveryPaymentViewController.swift
//  DeliverApp
//
//  Created by Admin on 8/13/19.
//  Copyright © 2019 User 2. All rights reserved.


import UIKit
import DLRadioButton

class DeliveryPaymentTypeViewController: UIViewController {
 
    
    @IBOutlet weak var itemTotal: UILabel!
    
    
    @IBOutlet weak var ItemTotalAmount: UILabel!
    
    @IBOutlet weak var itemTotalLabel: UILabel!
    
    
    @IBOutlet weak var paymentTypeTableView: UITableView!
    
    
    var headerTitle = [["Cash On Delivery"],["Paytm"],["Google Pay"]]
    
    var ArrayImages = [["CashOnDelivery"],["paytmImage"],["google pay"]]
    
    
    var selectedRow = 99999
    
    var selectedSection = 99999
    
    
    var userId:String = ""
    
    
    var totalAmount:Double = 0.0
    
    
    var itemTotalAmount:String = ""
    
    
    var totalItemAmount:String = "" 
    
     
    var summaryId:String = ""
    
    
    var radioButtonValue:String!
    
    var paymentTypeSelectedValue:String = ""
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
      paymentTypeTableView.rowHeight = 44
      paymentTypeTableView.estimatedRowHeight = UITableView.automaticDimension
    
       print(itemTotalAmount)
       print(totalItemAmount)
    
       userId = UserDefaults.standard.value(forKey: "user_id") as! String
    
       print("payment Type userId is",userId)
    
       self.itemTotal.text = itemTotalAmount
    
       print("summaryID is ",summaryId)
    
       setNavItemTop()
    
       print("paymentType Selected value",paymentTypeSelectedValue)
    
    }

func setNavItemTop(){
    
    
    self.title = "Payment Mode"
    
//   self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController)) 
    
    let leftBarbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(menuButtonTapped))
    
    self.navigationItem.leftBarButtonItem = leftBarbutton
    
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    self.navigationController!.navigationBar.tintColor = .white
    self.navigationController!.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]
    
 }
    
@objc fileprivate func menuButtonTapped() {
    
    self.dismiss(animated: true, completion: nil)
        
}
    
@IBAction func backBtnAction(_ sender: Any) {
    
        
        self.navigationController?.popViewController(animated: true)

   }
    
    
    @IBAction func submitPaymentTypeBtnAction(_ sender: Any) {
        
       ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/payment")!, params: ["user_id":userId,"summary_id":summaryId,"payment_type":radioButtonValue!,  "total_amt":itemTotalAmount],    viewcontroller: self, finish:finishPost)
        
  
}

 func finishPost(message:String, data:Data?)->Void{
        
        if let jsonData = data
        {
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] {
                
                print(json) 
                
                let getJsonOrderNumber = json["order_id"] as! String
                print("get Order Number is ",getJsonOrderNumber)
                
                
                let getJsonTotalAmount = json["total_amount"] as! Double
                print("get totalAmount is",getJsonTotalAmount)
                
                let getJsonDate = json["date"] as! String
                print("get date is ",getJsonDate)
                
                let getJsonTime = json["time"] as! String
                print("get time is",getJsonTime)
                
                
     if String(describing: json["success"]!) == "true" {
                    // if json["success"] as? String ?? "" == "success" {
                    print("delivery Payment type")
                    // UserDefaults.standard.set(updateUserId, forKey: "user_id")
                    //mobile text pass
                    
                       // var double = 2.225
                      //  var stringFromDouble = "\(double)"
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Alert", message:"Order Confirmation" , preferredStyle: .alert)
                                             
                          let okAction = UIAlertAction(title:"Proceed", style: .default) { (clickAct) in
                              
                         DispatchQueue.main.async {
                            let deliverySummarry = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryOrderPlaceViewController") as! DeliveryOrderPlacedViewController
                                     
                                     
                                     
                                     deliverySummarry.orderNumber = getJsonOrderNumber
                                     deliverySummarry.orderTotalAmount = getJsonTotalAmount
                                     deliverySummarry.orderDateday = getJsonDate
                                     deliverySummarry.orderTimeday = getJsonTime
                                     
                                         
                         self.navigationController?.pushViewController(deliverySummarry, animated: true)
                              
                             }
                          }
                           alert.addAction(okAction)
                        
                           DispatchQueue.main.async {
                              
                              self.navigationController?.present(alert, animated: true, completion: nil)
                          
                          }
                             
           
                    
                 
        
    }
                    
                }else{
                    
                    
                }
                
            }else{
                
                
            }
        }
    }
    
}

extension DeliveryPaymentTypeViewController:UITableViewDelegate,UITableViewDataSource{
    
func numberOfSections(in tableView: UITableView) -> Int{
    
    return headerTitle.count
 
}
        
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return headerTitle[section].count
    
 }
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableView.automaticDimension
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentTypeCell
    cell.paymentTypeName.text = headerTitle[indexPath.section][indexPath.row]
    cell.imageIcon.image = UIImage(named:ArrayImages [indexPath.section][indexPath.row])
    
     cell.payNowBtnProperty.setTitle("Pay now " + headerTitle[indexPath.section][indexPath.row] , for: .normal) 
    
     
    cell.payNowBtnProperty.tag = indexPath.row
    cell.payNowBtnProperty.tag = indexPath.section
    cell.payNowBtnProperty.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
    
    
    //button corner radius code
    
    cell.payNowBtnProperty.layer.cornerRadius = cell.payNowBtnProperty .frame.height/2
    
    cell.payNowBtnProperty.layer.cornerRadius = 15
    
    cell.payNowBtnProperty.clipsToBounds =  true
    
    
    if selectedSection == indexPath.section  {
        cell.heightForCell.constant = 30
        cell.payNowBtnProperty.isHidden = false
        cell.radioImage.image = UIImage(named: "SelectedRadioImage")
        
    }else{
        
        cell.heightForCell.constant = 0
        cell.payNowBtnProperty.isHidden = true
        cell.radioImage.image = UIImage(named: "UnSelectedRadioImage")
        
    }
    return cell
 }
    
    
@objc func buttonSelected(sender: UIButton){
    
 let rowvalue = sender.tag
    
    if rowvalue == 0 {
        
    ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/payment")!, params: ["user_id":userId,"payment_type":paymentTypeSelectedValue,  "total_amt":itemTotalAmount], viewcontroller: self, finish:finishPost)
        
        let cashOnDelivery = "Cash on Delivery"
        
        print("selectedpaymentoption %d" ,(cashOnDelivery))
        
           self.paymentTypeSelectedValue = cashOnDelivery
        
    }
    
else if rowvalue == 1 {
        
      let paytm = "Paytm"
        
      print("selected payment option %d", (paytm))

        paymentTypeSelectedValue = paytm
        
        
   
     
    }else if rowvalue == 2{
        
        
       let vc = storyboard?.instantiateViewController(withIdentifier: "PaytmPhoneNumberVerificationViewController") as! PaytmPhoneNumberVerificationViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        let GooglePay = "GooglePay"
        
  
        print("selectedpaymentoption %d" ,(GooglePay))
        
        
        paymentTypeSelectedValue = GooglePay
        
    }
    
}

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   
    return headerTitle[section][0]
        
 }
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
      
    selectedSection = indexPath.section
    selectedRow = indexPath.row
    paymentTypeTableView.reloadData()
    
  }
    
}

