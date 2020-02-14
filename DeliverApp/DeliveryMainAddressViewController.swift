//
//  DeliveryAddressViewController.swift
//  DeliverApp
//
//  Created by User 2 on 5/15/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
class AddressName: NSObject {
   
   var name: String!
   
   var street_address: String!
   
   var city : String!
   
   var area : String!
   
   var state : String!
   
   var type : String!
   
   var pincode : String!
   
   var mobile:String!
   
   var ID:String!
   
}

protocol CommentsDelegate {
    
    func commentsData(address:String,from: String,ID:String)
    
}
class DeliveryMainAddressViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate ,CommentsDelegate {
    
    
    var deliveryData: AddressName!
    
    var fromData: Int = 0  // 1-- from table // 2- from textfield manual entry
    

    var userId:String = "" 
    
    var name:String = ""
    var address:String = "" 
    var pincode:String = ""
    var city:String = ""
    var area:String = ""
    var state:String = ""
    var type:String = ""
    
    
    var data = [String:Any]()
    
    
    
    
    var getWeightUserSelected:String = ""
    var getPriceUser:String = "0.0"
    
    
    @IBOutlet weak var deliveryAddressBtnProperty: UIButton!
    
    @IBOutlet weak var ppSegment: UISegmentedControl!
    
    @IBOutlet weak var receiverNameTxtField: UITextField!
    
    @IBOutlet weak var deliveryAddressTxtField: UITextView!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    
    @IBOutlet weak var contactNoTxtField: UITextField!
    
    
    @IBOutlet weak var priceTeXtField: UITextField!
    
    
    @IBOutlet weak var weightAndGramsBtnProperty: UIButton!
    
    var tableAlert = UIAlertController()
    
    var tableview: UITableView!
    
   // let tableview = UITableView()
     var PapersArray : [papers] = []
     var parcelArray:  [parcels] = []
    
    var getUserSelectPapersOrParcels:String = ""
    
    
    //passing selected Date and time planyourPickup this class
    
    var currentDate:String = ""
    
    var getDeliverySelectedDate:String = ""
    
    var getDeliverySelectedTime:String = ""
    
    var pickUpID:String = ""
    
    var deliveryID:String = ""
    
    
    
 override func viewDidLoad() {
        super.viewDidLoad()
    
    
    
    
//    let gradientLayerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//    let gradient: CAGradientLayer = CAGradientLayer()
//    gradient.frame = gradientLayerView.bounds
//    // gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//
//    gradient.colors = [UIColor(red: 35/255, green: 151/255, blue: 215/255, alpha: 1).cgColor, UIColor(red: 111/255, green: 94/255, blue: 211/255, alpha: 1).cgColor]
//
//    //  gradient.locations = [0.0, 0.35]
//    gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
//    gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
//    gradientLayerView.layer.insertSublayer(gradient, at: 0)
//    self.view.layer.insertSublayer(gradientLayerView.layer, at: 0)


    
    
    
    
    
    
    deliveryAddressTxtField.delegate = self
    
    priceTeXtField.delegate = self
    priceTeXtField.isUserInteractionEnabled = false   //textfield price not editable
    
    setUpNav()
    
    userId = UserDefaults.standard.value(forKey:"user_id") as! String //pass as parameter in submit button
    print("myuserID",userId)
    
    print(getDeliverySelectedDate)
    print(getDeliverySelectedTime)
    
    print("pickupID is", pickUpID)
    print("deliveryID is",deliveryID)
    
    
    
        tableview = UITableView()
        tableview.delegate =  self
        tableview.dataSource = self
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    
    deliveryAddressBtnProperty.setImage(UIImage(named: "delivry"), for: .normal)
    
    print("mydata",data)
    area = data["area"] as? String ?? ""
    print("myArea",area)
    
    if fromData == 1{
        
        name = deliveryData.name ?? ""
        address = deliveryData.street_address ?? ""
        pincode = deliveryData.pincode ?? ""
        city    = deliveryData.city ?? ""
        area    = deliveryData.area ?? ""
        state   = deliveryData.state ?? ""
        type    = deliveryData.type ?? ""
        
        deliveryAddressTxtField.text = name + "," + address + "," + city + "," + area+"," + state + "," + pincode
        
    }else{
        print("myArea",area)
        name = data["name"] as? String ?? ""
        address = data["street_address"] as? String ?? ""
        pincode = data["pincode"] as? String ?? ""
        city    = data["city"] as? String ?? ""
        area = data["area"] as? String ?? ""
        print("myArea",area)
        state   = data["state"] as? String ?? ""
        type    = data["type"] as? String ?? ""
        
        if pincode != "" {
            //1
            deliveryAddressTxtField.text = name + "," + address + "," + city + "," + area+","  + state + "," + pincode
            //2
            // deliveryAddressTxtField.text = "\(name),\(address),\(city),\(state),\(pincode)"
            // deliveryAddressTxtField.text = "Name: \(name)\nAddress:\(address)\npincode: \(pincode)\ncity: \(city)\narea: \(area)\nstate: \(state)\ntype:\(type)"
        }else{
            //deliveryAddressTxtField.text = "" 
            
        }
    }


    ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/parcellist")!, params: [:],viewcontroller: self, finish: parcellistfinishPost)
    //for test
     ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/paperlist")!, params: [:],viewcontroller: self, finish: paperlistfinishPost)
        
    }
    
    
 // Implement the delivery saveAndRecentAddressController
func commentsData(address:String,from:String,ID:String){
        
        print(address)
        self.deliveryAddressTxtField.text = address
        deliveryID = ID
 
 }
    
    
func setUpNav(){
        self.title = "Delivery Address"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissVC))
    
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(menuButtonTapped))
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem
    

         //setting the color navigation item in top bellow line code
      // navigationController?.navigationBar.barTintColor = UIColor.brown
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    self.navigationController!.navigationBar.tintColor = .white
    self.navigationController!.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]
    
    
 }
    @objc fileprivate func menuButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
//   @objc func dismissVC() {
//        self.dismiss(animated: true, completion: nil)
// }
    
    @IBAction func papersAndParcelsSelectionSegment(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            //tableview.tag = 0
            let title = ppSegment.titleForSegment(at: ppSegment.selectedSegmentIndex)
           // print("parcels")
             print(title!)
            getUserSelectPapersOrParcels = title!
            
//            ApiService.callPost(url: URL.init(string: " http://goflexi.in/ecommerce/delivery/APP/API/pdapi/parcellist")!, params: [:],viewcontroller: self, finish: parcellistfinishPost)
            
        }
        else{
             let title = ppSegment.titleForSegment(at: ppSegment.selectedSegmentIndex)
            // print("paper")
             print(title!)
            getUserSelectPapersOrParcels = title!
            
          
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
     alert.view.tintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    
    self.present(alert, animated: true, completion: nil)
        
  }
 func formValidation() -> Bool {
        
        if weightAndGramsBtnProperty.currentTitle == "" {
            
            showAlert(msg:"select Weight")
            return false
            
        }else if receiverNameTxtField.text == "" {
            showAlert(msg:"Enter Receiver Name")
            return false
            
        }else if deliveryAddressTxtField.text == "" {
            showAlert(msg:"Enter Delivery Address")
            
       
            
        }else if emailTxtField.text == "" {
            
            showAlert(msg:"Enter Email")
            return false
            
        }else if contactNoTxtField.text == ""{
            
            showAlert(msg:"Enter mobile number")
            return false
            
    }
        return true
        
        
    }
    
    @IBAction func deliveryAddressFillViewAction(_ sender: Any) {
        
        let deliverySaveRecentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeliverySaveAndRecentAddressController") as! DeliverySaveAndRecentAddressController
        deliverySaveRecentViewController.vDelegate = self
        
        let navgation = UINavigationController(rootViewController: deliverySaveRecentViewController)
        
       self.present(navgation, animated: true, completion: nil) 
    
 }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        guard formValidation() == true else {
            return

        }
        
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliveryinfo")!, params: ["user_id":userId, "name" : receiverNameTxtField.text! , "address" :deliveryAddressTxtField .text!,"mobile" : contactNoTxtField.text! , "email" :emailTxtField.text! ,"weight" :getWeightUserSelected,"price":getPriceUser], viewcontroller: self, finish:finishPost)
        
  }
    
func finishPost(message:String, data:Data?)->Void{
        
        if let jsonData = data
        {
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                
//                let getuserid = json["userid"] as! String
//                print("myUserId",getuserid)
//                updateUserId = getuserid
//
//                let getMobileNo = json["usermobile"] as! String
//                print("myMobileno",getMobileNo)
//
            //if String(describing: json["success"]!) == "true" {
                if json["err_msg"] as? String ?? "" == "success" {
                    print(" delivery submited")
                   // UserDefaults.standard.set(updateUserId, forKey: "user_id")
                    //mobile text pass
                    
                    
                    let deliverySummarry = storyboard?.instantiateViewController(withIdentifier: "DeliverySummaryViewController") as! DeliverySummaryViewController
                    
                    deliverySummarry.Weight = getWeightUserSelected
                    deliverySummarry.price =  Double(getPriceUser)!
                    
                    deliverySummarry.currentDate = currentDate
                    deliverySummarry.deliveryDate = getDeliverySelectedDate //get this date planpickup class
                   deliverySummarry.deliveryTime = getDeliverySelectedTime //get this date planpickup class
                    //get user selected paper or parcels from segment
                    
                    deliverySummarry.papersOrParcels = getUserSelectPapersOrParcels
                    deliverySummarry.deliveryAddress = deliveryAddressTxtField
                    
                    deliverySummarry.getPickUpIDFromDeliveryMainVc = pickUpID
                    deliverySummarry.getDeliveryIDFromDeliveryMainVc = deliveryID
                    
                    
                    let nav = UINavigationController(rootViewController: deliverySummarry)

                DispatchQueue.main.async {

                        self.present(nav, animated: true, completion: nil)
                    }

                }else{
                    let alertmsg = json["err_msg"] as? String ?? ""
                    //show alert here
                    let alert = UIAlertController(title: "Alert", message:alertmsg , preferredStyle: UIAlertController.Style.alert)
                    let clickAction = UIAlertAction(title: "Go to login", style: .default) { (clickAct) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(clickAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }

                }
                
            }else{
                
                showAlert(msg:"something went wrong")
            }
        }
    }
    
 }

extension DeliveryMainAddressViewController:UITableViewDelegate,UITableViewDataSource{
    
    @IBAction func weightAndGramsButtonAction(_ sender: Any) {

    tableAlert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
      
        tableview.frame = CGRect(x: 7.0, y: 5.0, width: 270, height: 210)
        
       // tableAlert.view.layer.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor
      //  tableview.backgroundColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
        
        tableAlert.view.addSubview(tableview)
        tableAlert.view.layer.borderWidth = 1.0
        tableAlert.view.layer.cornerRadius = 30
        tableAlert.view.layer.masksToBounds = true
        tableAlert.view.layer.borderColor = UIColor(red: 27/255, green: 166/255, blue: 236, alpha: 1).cgColor
        
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
        
        Cell.textLabel?.text = "Weight: \(weigt)"   ///", Price: \(price)"
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
}
    
 public class parcels: NSObject {
        
        var ID: String?
        
        var weight: String?
        
        var price: String?
        
        
    }
    
    
class papers: NSObject {
    
    var ID: String?
    
    var weight: String?
    
    var price : String?
    
    }
 


