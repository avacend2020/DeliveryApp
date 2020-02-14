//
//  DocumentVC.swift
//  PIK N DROP
//
//  Created by Admin on 12/25/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import iOSDropDown

typealias Callback = ((String,String)->(Void))
class DocumentVC: UIViewController,UITextFieldDelegate{
    
     var delegate :Callback?
    
    
    var selectedItemPaperPacel:String = ""
    
    var selectedWeight:String = ""
    
    var selectedPrice:String = ""
    
    
    @IBOutlet weak var doneButtonProperty: UIButton!
    @IBOutlet weak var weightCat: DropDown!
    @IBOutlet weak var txtCatgory: DropDown!
    
    var PapersArray : [papers] = []
    var parcelArray:  [parcels] = []
    var selectedItem : SelectedDoc?{
        
        didSet{
          
           
        }
    }
    
@IBOutlet weak var txtPrice: UITextField!
    

override func viewDidLoad() {
        super.viewDidLoad()
        
    doneButtonProperty.layer.cornerRadius = doneButtonProperty.frame.height/2
    doneButtonProperty.clipsToBounds =  true
    
    txtCatgory.selectedRowColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    weightCat.selectedRowColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    
  }
    
func setupuAction(callback:@escaping Callback) {
    
        self.delegate = callback
  
    }
    
override func viewWillAppear(_ animated: Bool) {
        weightCat.text = ""
        txtPrice.text = ""
        if  AppConstants.Documents != nil{
            txtCatgory.text = AppConstants.Documents?.CatName
            weightCat.text = AppConstants.Documents?.weight
            txtPrice.text = AppConstants.Documents?.price
        }
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/parcellist")!, params: [:],viewcontroller: self, finish: parcellistfinishPost)
           //for test
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/paperlist")!, params: [:],viewcontroller: self, finish: paperlistfinishPost)
        
        txtCatgory.optionArray = ["Papers", "Parcels"]
                     
//        selectedItemPaperPacel = txtCatgory.text!
//        print(selectedItemPaperPacel)
                    
                    // Its Id Values and its optional
                    txtCatgory.optionIds = [1,23,54,22]
               
                    // The the Closure returns Selected Index and String
                    txtCatgory.didSelect{(selectedText , index ,id) in
                        self.weightCat.text = ""
                        self.txtPrice.text = ""
                        self.setUpSubCat(type: index)
                    self.selectedItemPaperPacel = selectedText
                        
                    print("category Type Selecdrted is", self.selectedItemPaperPacel)
                       // self.selectedItemPaperPacel = selectedText
                        
            }
             
    }
func setUpSubCat(type:Int){
    
        var array = [String]()
            if type == 0 {
                for weight in self.PapersArray {
                   array.append(weight.weight ?? "")
                }
            }else{
               for weight in self.parcelArray {
                   array.append(weight.weight ?? "")
               }
           }
             self.selectedItem = nil
                // The list of array to display. Can be changed dynamically
             weightCat.optionArray = array
               // Its Id Values and its optional
             weightCat.optionIds = [1,23,54,22]
               // The the Closure returns Selected Index and String
             weightCat.didSelect{(selectedText , index ,id) in
                
                if type == 0 {
                    self.selectedItem = SelectedDoc(ID: self.PapersArray[index].ID ?? "", weight: self.PapersArray[index].weight ?? "", price: self.PapersArray[index].price ?? "", CatName: "Papers")
                    self.txtPrice.text = self.PapersArray[index].price ?? ""
                }else{
                      self.selectedItem = SelectedDoc(ID: self.parcelArray[index].ID ?? "", weight: self.parcelArray[index].weight ?? "", price: self.parcelArray[index].price ?? "", CatName: "Parcels")
                    self.txtPrice.text = self.PapersArray[index].price ?? ""
                }
             }
        
    }
    
@IBAction func btnClickNext(_ sender: Any) {
        
        AppConstants.Documents = self.selectedItem
    
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliveryinfo")!, params: ["user_id":"1","package_type":selectedItemPaperPacel,  "weight" :self.selectedItem?.weight ?? "","price":self.selectedItem?.price ?? ""], viewcontroller: self, finish:finishPost)
   }
    
 @IBAction func cancelBtnAction(_ sender: Any) {
        
     self.dismiss(animated: true, completion: nil)
        
 }
    
 func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
        if textField == weightCat{
            self.weightCat.showList()
        }else{
            self.txtCatgory.showList()
        }
        return false
    }
}

extension DocumentVC{
    
    
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
                                if  AppConstants.Documents != nil{
                                    if AppConstants.Documents?.CatName?.contains("Parcel") ?? false{
                                          self.setUpSubCat(type: 1)
                                    }
                                }
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
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] {  
                        
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
                                if  AppConstants.Documents != nil{
                                   if AppConstants.Documents?.CatName?.contains("Paper") ?? false{
                                       self.setUpSubCat(type: 0)
                                   }
                               }
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
func finishPost(message:String, data:Data?)->Void{
            
            if let jsonData = data
            {
                if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                    print(json)
                    
                    let  jsonprice = json["price"] as! String
                    
                    selectedPrice = jsonprice
                    
                    print("Selected price is",selectedPrice)
                    
                    let jsonWeight = json["weight"] as! String
                    
                    selectedWeight = jsonWeight
                    
                    print("Selected weight is",selectedWeight)
                    
                    
                    
                //if String(describing: json["success"]!) == "true" {
                    if json["err_msg"] as? String ?? "" == "success" {
                        print(" delivery submited")
                        
                        DispatchQueue.main.async {
                            self.delegate!(self.selectedPrice, self.selectedWeight)
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
                     
                         
                 
                }
            }
        }
        
    
}
