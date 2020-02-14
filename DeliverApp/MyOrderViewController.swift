//
//  MyOrderViewController.swift
//  DeliverApp
//
//  Created by User 2 on 4/29/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class MyOrderViewController: UIViewController {
    
    
    
    @IBOutlet weak var navigationbarOutlet: UINavigationItem!
    
    
    @IBOutlet weak var orderHistoryTableview: UITableView!
    
  
   
    
    
    
    var orderHistoryArray = [MyOrders]()
    
    
    
    var userId:String = "" 
    var totalAmountOfOrder:String = "" 
    var selectionPaymentType:String = ""
    var deliveryDateOfOrder:String = ""
    var orderSatus:String = ""
    
    
    
 override func viewDidLoad() {
        super.viewDidLoad()
    

    self.navigationbarOutlet.title = "My Orders"
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .done, target: self, action: #selector(menuAction))
    
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    self.navigationController!.navigationBar.tintColor = .white
    self.navigationController!.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]

    userId = UserDefaults.standard.value(forKey: "user_id") as! String
     print("userId is",userId)
        
        
    // here we call api to show order history
    
      ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/orderhistory")!, params: ["user_id":userId], viewcontroller: self, finish:finishPost)
    
    
    orderHistoryTableview.estimatedRowHeight = 44
    orderHistoryTableview.rowHeight = UITableView.automaticDimension

     //"summary_id":summaryId,"payment_type":radioButtonValue!,  "total_amt":totalAmount
    
    
}

@objc func menuAction() {
        
        
 }
    
func finishPost(message:String, data:Data?)->Void{
    do{
        if let jsonData = data
        {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                
//                "delivery_date" = "05-Oct-2019";
//                "order_number" = 1;
//                "order_status" = Processing;
//                "payment_type" = "Cash On Delivery";
//                price = "11.2";
//                "user_id" = 1;
      
                
                if String(describing: json["err_msg"]!) == "success" {
                    
                    print("Order History")
                   
                    let orderDictionaryDict = json["order_history"] as? NSDictionary ?? [:]
                    
                    guard orderDictionaryDict.count > 0 else{
                        
                        return
                        
                    }
                    
                    for i in 0...orderDictionaryDict.count - 1 {
                        
                        let dict = orderDictionaryDict.value(forKey: "\(i+1)") as? [String:AnyObject] ?? [:]
                        
                        
                        let diveryDate = dict["delivery_date"] as? String
                        
                         let orderNumber = dict["order_number"] as? String
                           let oredrSataus = dict["order_status"] as? String
                         let paymentType = dict["payment_type"] as? String
                         let price = dict["price"] as? String
                        
                        let data = MyOrders()
                        
                        data.orderId = orderNumber
                        data.date = diveryDate
                        data.orderStatus = oredrSataus
                        
                        data.priceAndType = paymentType
                        data.price = price
                        
                     orderHistoryArray.append(data)
                        
                        
                        
        }
                    DispatchQueue.main.async {
                        self.orderHistoryTableview.reloadData()
                    }
                        
             }
                
            }
    }
        }catch(let error){
            
        }
        
    }
    
    
}
extension MyOrderViewController:UITableViewDelegate,UITableViewDataSource{
    
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return orderHistoryArray.count
        
 }
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderHistoryCell
    
    let dict = orderHistoryArray[indexPath.row]
    
    cell.deliveryDate.text = dict.date
    cell.orderID.text = dict.orderId
   // cell.orderStatus.text = dict.orderStatus
    cell.priceAndType.text = dict.priceAndType
   // cell.priceLabel.text = dict.price
    
    cell.priceLabel.text = "₹" + String(format: dict.price)
   // self.priceLabel.text = "₹" + String(format:"%..2f", price)
    
   cell.loadData()

    return cell
 
    }
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
    
    let orderIDPassDetailVc = orderHistoryArray[indexPath.row]
    
    vc.orderIdGettingOrderDetail = orderIDPassDetailVc.orderId
    
  // print("****** orderID is ******",orderIdGettingOrderDetail)
   
    
     self.navigationController?.pushViewController(vc, animated: true)
    
   // self.present(vc, animated: true, completion: nil)
    
    }
 
    
}



class MyOrders:NSObject{
    
    var orderId:String!
    
    var date:String!
    
    var orderStatus:String!
    
    var priceAndType:String!
    
    var price:String!
    
}

