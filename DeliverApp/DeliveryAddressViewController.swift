//
//  DeliveryAddressViewController.swift
//  DeliverApp
//
//  Created by User 2 on 5/15/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class DeliveryMainAddressViewController: UIViewController  {
    
    
    var userID:String = ""
    var getWeightUserSelected:String = ""
    var getPriceUser:String = ""
    
    
    @IBOutlet weak var deliveryAddressBtnProperty: UIButton!
    
    
    
    
    
    
    
    @IBOutlet weak var ppSegment: UISegmentedControl!
    
    @IBOutlet weak var receiverNameTxtField: UITextField!
    
    @IBOutlet weak var deliveryAddressTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    
    @IBOutlet weak var contactNoTxtField: UITextField!
    
    
    
    @IBOutlet weak var priceTextfieldProperty: UITextField!
    
    @IBOutlet weak var priceTeXtField: UITextField!
    @IBOutlet weak var weightAndGramsBtnProperty: UIButton!
    
    var tableAlert = UIAlertController()
    
    var tableview: UITableView!
    
   // let tableview = UITableView()
     var PapersArray : [papers] = []
     var parcelArray:  [parcels] = []
    
 override func viewDidLoad() {
        super.viewDidLoad()
    
    
    
        tableview = UITableView()
        tableview.delegate =  self
        tableview.dataSource = self
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    
    deliveryAddressBtnProperty.setImage(UIImage(named: "delivry"), for: .normal)
    
    
    userID = UserDefaults.standard.value(forKey:"user_id") as! String //pass as parameter in submit button
    print("myuserID",userID)
    
    // for test
    ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/parcellist")!, params: [:],viewcontroller: self, finish: parcellistfinishPost)
    //for test
     ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/paperlist")!, params: [:],viewcontroller: self, finish: paperlistfinishPost)
        
    }
    
    @IBAction func papersAndParcelsSelectionSegment(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            //tableview.tag = 0
            
//            ApiService.callPost(url: URL.init(string: " http://goflexi.in/ecommerce/delivery/APP/API/pdapi/parcellist")!, params: [:],viewcontroller: self, finish: parcellistfinishPost)
            
        }
        else{
            
            //tableview.tag = 1
//            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/paperlist")!, params: [:],viewcontroller: self, finish: paperlistfinishPost)
        }
        
    }
func parcellistfinishPost (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    
                    print(json)
                    
                    
                    if let parcelListDict = json["parcel"] as? NSDictionary {
                        
                        for rest in parcelListDict{
                            
                            
                            let obj = parcels()
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                            
                            obj.ID = values.value(forKey: "ID") as? String
                            obj.weight = values.value(forKey: "weight") as? String
                            obj.price = values.value(forKey: "price") as? String
                            
                            parcelArray.append(obj)
                        }
                        
                        DispatchQueue.main.async {
                            
                            print("get result")
                        }
                        
                    }
                }
                
                
            }else{
                
                DispatchQueue.main.async {
                    
                    
                }
                
            }
        } catch {
            
            print("error")
            
        }
    }


    
    
    
func paperlistfinishPost (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    
                    print(json)
                    
                    
                    if let paperListDict = json["paper"] as? NSDictionary {
                        
                        for rest in paperListDict{
                            
                            
                            let obj = papers()
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                            
                            obj.ID = values.value(forKey: "ID") as? String
                            obj.weight = values.value(forKey: "weight") as? String
                            obj.price = values.value(forKey: "price") as? String
                            
                            PapersArray.append(obj)
                        }
                        
                        DispatchQueue.main.async {
                            
                            print("get result")
                        }
                        
                    }
                }
                
                
            }else{
                
                DispatchQueue.main.async {
                    
                    
                }
                
            }
        } catch {
            
            print("error")
            
        }
 }
    
func showAlert(msg: String) {
        
        let alert = UIAlertController(title: "Alert", message:msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
  }
 func formValidation() -> Bool {
        
        if weightAndGramsBtnProperty.currentTitle == "" {
            
            showAlert(msg: "select Weight")
            return false
            
        }else if receiverNameTxtField.text == "" {
            showAlert(msg: "Enter Receiver Name")
            return false
            
        }else if deliveryAddressTxtField.text == "" {
            showAlert(msg: "Enter delivery Address")
            
       
            
        }else if emailTxtField.text == "" {
            
            showAlert(msg: "Enter Email")
            return false
            
        }else if contactNoTxtField.text == ""{
            
            showAlert(msg: "Enter mobile number")
            return false
            
    }
        return true
        
        
    }
    
    @IBAction func deliveryAddressFillViewAction(_ sender: Any) {
        
        let deliverySaveRecentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeliverySaveAndRecentAddressController") as! DeliverySaveAndRecentAddressController
        self.present(deliverySaveRecentViewController, animated: true, completion: nil)
     
        
        
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        
        
    }
    
 }

extension DeliveryMainAddressViewController:UITableViewDelegate,UITableViewDataSource{
    
    @IBAction func weightAndGramsButtonAction(_ sender: Any) {

    tableAlert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
      
        tableview.frame = CGRect(x: 5.0, y: 5.0, width: 250, height: 200)
        tableAlert.view.addSubview(tableview)
        
        tableAlert.view.layer.borderWidth = 1.0
        tableAlert.view.layer.masksToBounds = true
        tableAlert.view.layer.borderColor = UIColor.brown.cgColor
        tableAlert.view.clipsToBounds = true
        
         self.tableview!.reloadData()
        
        self.present(tableAlert, animated: true, completion: nil)
        
 }
    //1
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if ppSegment.selectedSegmentIndex == 0 {
        
        return parcelArray.count
        
    }else
    {
       
        return PapersArray.count
    }
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let Cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    if ppSegment.selectedSegmentIndex == 0 {
        
        
        let obj = parcelArray[indexPath.row]
        
        let weight = obj.weight ?? ""
        let price = obj.price ?? ""
        Cell.textLabel?.text = "weight: \(weight)"
        // Cell.textLabel?.text = price
       //Cell.textLabel?.text = "nage"

        
    }else{

        let obj = PapersArray[indexPath.row]
        
        let weigt = obj.weight ?? ""
        let price = obj.price ?? ""
        
        Cell.textLabel?.text = "Weight: \(weigt)"///", Price: \(price)"
          }
    return Cell
    
    }
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if ppSegment.selectedSegmentIndex  == 0 {
        let weight = parcelArray[indexPath.row].weight!
        let price = parcelArray[indexPath.row].price!
        weightAndGramsBtnProperty.setTitle(weight, for: .normal)
        print(weight)
        getWeightUserSelected = weight
        
        priceTeXtField.text = price
        print(price)
        getPriceUser = price
        
        self.tableAlert.dismiss(animated: true, completion: nil)
        
    }else{
        let weight = PapersArray[indexPath.row].weight!
        
        let price = PapersArray[indexPath.row].price!
        weightAndGramsBtnProperty.setTitle(weight, for: .normal)
        print(weight)
        getWeightUserSelected = weight
        
        priceTeXtField.text = price
        print(price)
        getPriceUser = price
        
        self.tableAlert.dismiss(animated: true, completion: nil)
        
        }
}
    
class parcels: NSObject {
        
        var ID: String?
        
        var weight: String?
        
        var price: String?
        
        
    }
    
    
class papers: NSObject {
    
    var ID: String?
    
    var weight: String?
    
    var price : String?
    
    }
 

}

