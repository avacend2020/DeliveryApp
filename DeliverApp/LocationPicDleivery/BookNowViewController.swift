//
//  AddressBottomSheetViewController.swift
//  DeliverApp
//
//  Created by User 2 on 5/2/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation

struct AddressModel{
    
      var addressArray = [Address]()
      var headerName = ""
     init( addressArray : [Address] , headerName : String) {
         self.addressArray = addressArray
         self.headerName = headerName 
     }
}

class BookNowViewController: UIViewController {
    
    var isPickup = true
    var userId:String = ""
    @IBOutlet weak var txtSearch: UITextField!
    var pickup_status:String = ""
    var txt:String = "Search for pickup location"
    @IBOutlet var tblRecentList: UITableView!
    @IBOutlet var tblSavedList: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    var imagesArrray : Array<UIImage>?
    var buttonNameArray : Array<String>?
    var savedArray : AddressModel?
    var recentArray : AddressModel?
     @IBOutlet weak var heightSavedList: NSLayoutConstraint!
    @IBOutlet weak var heightRecentList: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.heightSavedList.constant = 0
         self.heightRecentList.constant = 0
         tblRecentList.isHidden = true
         tblSavedList.isHidden = true
        
        if isPickup == true {
            
            textLabel.text = "Search for pickup location"
            textLabel.font = UIFont.init(name:"Avenir Next" , size: 13)
            
        }else{
            
            textLabel.text = "Search for drop location"
            textLabel.font = UIFont.init(name:"Avenir Next", size: 13)
  }
        
      setupNavigation()
        
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        print("myUserid is",userId)
        imagesArrray = [UIImage.init(named: "Search-1")] as? Array<UIImage>
        buttonNameArray = ["Address search e.g. Niligiri's HSR"]//,"Manual"]
        tblRecentList.estimatedRowHeight = 44
        tblRecentList.rowHeight = UITableView.automaticDimension
        if isPickup{
            finishPostrecent(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/recent_addresslist")
            
        }else{
            finishPostrecent(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/recent_deliveryaddresslist")

        }
    }
    
    func setupNavigation() {
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
        self.navigationController!.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
    }
    
 @IBAction func backPopViewButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
   
   }

}

extension BookNowViewController : UITextFieldDelegate,GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.dismiss(animated: false, completion: nil)
        let bookNowView =  self.storyboard?.instantiateViewController(withIdentifier: "GoogleMapPickUPViewController") as! GoogleMapPickUPViewController
        bookNowView.formattedAddress = place.formattedAddress ?? ""
        bookNowView.coordinate = place.coordinate
        bookNowView.isPickup = self.isPickup
        self.navigationController?.pushViewController(bookNowView, animated: true)
       
    }
func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
         self.dismiss(animated: false, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         presentAutoComplete()
        return false
    }
func presentAutoComplete(){
         let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self
           let filter = GMSAutocompleteFilter()
           filter.type = .establishment
           filter.country = "IND"
           autocompleteController.autocompleteFilter = filter
           self.present(autocompleteController, animated: false, completion: nil)
    }
}
extension BookNowViewController : UITableViewDelegate , UITableViewDataSource{
    
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblRecentList {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "GoogleMapPickUPViewController") as! GoogleMapPickUPViewController
            if let obj = recentArray?.addressArray[indexPath.row]{
              let nameS = obj.name
              let streetS = obj.street_address != "" ? (" " + obj.street_address) : ""
              let cityS = obj.city != "" ? ( "," + obj.city) : ""
              let areaS = obj.area != "" ? ( "," + obj.area) : ""
              let stateS = obj.state != "" ? ("," + obj.state) : ""
              let pincode = obj.pincode != "" ? ("," + obj.pincode) : ""
              let MobileS = obj.mobile != "" ? ("," + obj.mobile) : ""
              let flatno = obj.flat_no != "" ? (" " + obj.flat_no!) : ""
              let appartmentname = obj.apartment_name != "" ? (" " + obj.apartment_name!) : ""
                

         // let fulltext = "\(nameS!)\(streetS)\(cityS)\(stateS)\(areaS)\(MobileS) \(pincode)\(flatno)\(appartmentname)"
                
                
                
            let fulltext = streetS
                
             print(fulltext)
                
                
                
            vc.formattedAddress = fulltext
            
            let fullName = nameS!
            vc.nameGetInBookNOW = fullName
            
            let fullHouseNo = flatno
            vc.flat_no = fullHouseNo
            
            let appartmentName = appartmentname
            vc.apartment_name = appartmentName
                
                
            let streetAddress = streetS
            vc.street_address = streetAddress
                
             
      if let lattiude = CLLocationDegrees(exactly: Double(obj.latitude_number ?? "0") ?? 0), let longituode = CLLocationDegrees(exactly: Double(obj.longitude_number ?? "0") ?? 0){
                
            vc.isPickup = self.isPickup
            vc.coordinate = CLLocationCoordinate2D(latitude: lattiude, longitude: longituode)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
     
     }
            
        }else{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "GoogleMapPickUPViewController") as! GoogleMapPickUPViewController
            if let obj = savedArray?.addressArray[indexPath.row]{
              let nameS = obj.name
              let streetS = obj.street_address != "" ? ("" + obj.street_address) : ""
              let cityS = obj.city != "" ? ( " " + obj.city) : ""
              let areaS = obj.area != "" ? ( " " + obj.area) : ""
              let stateS = obj.state != "" ? (" " + obj.state) : ""
              let pincode = obj.pincode != "" ? (" " + obj.pincode) : ""
              let MobileS = obj.mobile != "" ? (" " + obj.mobile) : ""
              let flatno = obj.flat_no != "" ? (" " + obj.flat_no!) : ""
              let appartmentname = obj.apartment_name != "" ? (" " + obj.apartment_name!) : ""
                
//             let fulltext = "\(nameS!)\(streetS)\(cityS)\(stateS)\(areaS)\(MobileS) \(pincode)\(flatno)\(appartmentname)"
                
                
                
            let fulltext = streetS
            print(fulltext)
                
                
            vc.formattedAddress = fulltext
            
            let fullName = nameS!
            vc.nameGetInBookNOW = fullName
            
            let fullHouseNo = flatno
            print(fullHouseNo)
            vc.flat_no = fullHouseNo
                
                
            let appartmentName = appartmentname
            vc.apartment_name = appartmentName
                
            let streetAddress = streetS
            vc.street_address = streetAddress
                
                
            if let lattiude = CLLocationDegrees(exactly: Double(obj.latitude_number ?? "0") ?? 0), let longituode = CLLocationDegrees(exactly: Double(obj.longitude_number ?? "0") ?? 0){
                
            vc.isPickup = self.isPickup
                
            vc.coordinate = CLLocationCoordinate2D(latitude: lattiude, longitude: longituode)
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
          
          }
            
        }
    }
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == tblRecentList {
        return recentArray?.addressArray.count ?? 0
    }else{
         return savedArray?.addressArray.count ?? 0
    }
 }
    
func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let viewMain = UIView()
        let lbl = UILabel()
        viewMain.addSubview(lbl)
        if tableView == tblRecentList {
            lbl.text = recentArray?.headerName
        }else{
            lbl.text = savedArray?.headerName
        }
        lbl.fillSuperview(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        viewMain.backgroundColor = .lightGray
        return viewMain
    }
    
func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    
        return 100
   
  }
    
func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return 40
 }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
   let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationCell_ID") as! RecentLocationCell
         cell.selectionStyle = .none
    
        if tableView == tblRecentList {
            
           if let obj = recentArray?.addressArray[indexPath.row]{
                 let nameS = obj.name
                 let streetS = obj.street_address != "" ? ("," + obj.street_address) : ""
                 let cityS = obj.city != "" ? ( "," + obj.city) : ""
                 let areaS = obj.area != "" ? ( "," + obj.area) : ""
                 let stateS = obj.state != "" ? ("," + obj.state) : ""
                 let pincode = obj.pincode != "" ? ("," + obj.pincode) : ""
                 let MobileS = obj.mobile != "" ? ("," + obj.mobile) : ""
                 let flatno = obj.flat_no != "" ? ("," + obj.flat_no!) : ""
               let appartmentname = obj.apartment_name != "" ? ("," + obj.apartment_name!) : "" 
            
            
                 cell.locationLbl.text = "\(nameS!)\(streetS)\(cityS)\(stateS)\(areaS)\(MobileS) \(pincode)\(flatno)\(appartmentname)"
            
                 cell.locationLbl.font = UIFont(name:"Avenir Next", size: 15)
                 
                 if obj.type == "home"{
                     cell.locationImage.image = UIImage.init(named: "homeAddress")
                 }else  if obj.type == "office"{
                     cell.locationImage.image = UIImage.init(named: "manual")
                 }else{
                     cell.locationImage.image = UIImage.init(named: "others")
                 }
            }
                 return cell
       }else{
          if let obj = savedArray?.addressArray[indexPath.row]{
                     let nameS = obj.name
                     let streetS = obj.street_address != "" ? ("," + obj.street_address) : ""
                     let cityS = obj.city != "" ? ( "," + obj.city) : ""
                     let areaS = obj.area != "" ? ( "," + obj.area) : ""
                     let stateS = obj.state != "" ? ("," + obj.state) : ""
                     let pincode = obj.pincode != "" ? ("," + obj.pincode) : ""
                     let MobileS = obj.mobile != "" ? ("," + obj.mobile) : ""
                     let flatno = obj.flat_no != "" ? ("," + obj.flat_no!) : ""
                     let appartmentname = obj.apartment_name != "" ? ("," + obj.apartment_name!) : ""
            
            
                   
                     
                     cell.locationLbl.text = "\(nameS!)\(streetS)\(cityS)\(stateS)\(areaS)\(MobileS) \(pincode)\(flatno)\(appartmentname)"
            
                     cell.locationLbl.font = UIFont(name:"Avenir Next", size: 15)
                     
                     if obj.type == "home"{
                         cell.locationImage.image = UIImage.init(named: "homeAddress")
                     }else  if obj.type == "office"{
                         cell.locationImage.image = UIImage.init(named: "manual")
                     }else{
                         cell.locationImage.image = UIImage.init(named: "others")
                     }
                }
                     return cell
       }
       
      
    }
    
    func checkNull(value: AnyObject) -> String {
        return ""
    }
    
}

extension BookNowViewController{

 func finishPostrecent(urlStr:String){
        
        ApiService.callPost(url: URL.init(string: urlStr)!, params: ["user_id" :userId],viewcontroller: self) { (message, data) in
            do {
                           if let jsonData = data
                           {
                               if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] {
                                   print(json)
                                     var addressSubArray = [Address]()
                                   if let restaurantsDict = json["recent_address"] as? NSDictionary {
                                       for i in 0...restaurantsDict.count - 1 {
                                           let values = restaurantsDict.value(forKey: "\(i+1)") as? NSDictionary ?? [:]
                                           print("**************************************************")
                                           print(values)
                                           let obj = Address()
                                           print(values)
                                           obj.name = values.value(forKey: "name") as? String ?? ""
                                           obj.street_address = values.value(forKey: "street_address") as? String ?? ""
                                           obj.area = values.value(forKey: "area") as? String ?? ""
                                           obj.city = values.value(forKey: "city") as? String ?? ""
                                           obj.pincode = values.value(forKey: "pincode") as? String ?? ""
                                           obj.state = values.value(forKey: "state") as? String ?? ""
                                           obj.type = values.value(forKey: "type") as? String ?? ""
                                           obj.addressID = values.value(forKey: "id") as? String ?? ""
                                           obj.mobile = values.value(forKey: "mobile") as? String ?? ""
                                       obj.flat_no = values.value(forKey: "flat_no") as? String ?? ""
                                        obj.apartment_name = values.value(forKey: "apartment_name") as? String ?? ""
                                                                       
                                        
                                           addressSubArray.append(obj)
                                           print("addressArray is",addressSubArray)
                                       }
                                       let adress = AddressModel(addressArray: addressSubArray, headerName: "Recent Searches")
                                       self.recentArray = adress
                                       DispatchQueue.main.async {
                                         //self.addressArray.reverse()
                                       
                                        self.heightRecentList.constant = self.view.frame.height / 2
                                        self.tblRecentList.isHidden = false
                                           self.tblRecentList.reloadData()
                                       }
                                    if self.isPickup{
                                       self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/save_addresslist")
                                   }else{
                                        self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverysave_addresslist")
                                   }
                                   }else{
                                    if self.isPickup{
                                        self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/save_addresslist")
                                    }else{
                                         self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverysave_addresslist")
                                    }
                                  }
                               }
                           }else{
                               DispatchQueue.main.async {
                                    if self.isPickup{
                                        self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/save_addresslist")
                                    }else{
                                        self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverysave_addresslist")
                                    }
                               }
                           }
                       } catch {
                           print("error")
                        if self.isPickup{
                             self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/save_addresslist")
                         }else{
                             self.finishPostsaved(urlStr: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverysave_addresslist")
                         }
                       }
        }
    }
    
func finishPostsaved (urlStr:String)
        {

            ApiService.callPost(url: URL.init(string: urlStr)!, params: ["user_id" :userId],viewcontroller: self) { (message, data) in
                       do {
                if let jsonData = data
                {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] {
                        print(json)
                        var addressSubArray = [Address]()
                        if let restaurantsDict = json["recent_address"] as? NSDictionary {
                            for i in 0...restaurantsDict.count - 1 {
                                let values = restaurantsDict.value(forKey: "\(i+1)") as? NSDictionary ?? [:]
                                print("**************************************************")
                                print(values)
                                let obj = Address()
                                print(values)
                                obj.name = values.value(forKey: "name") as? String ?? ""
                                obj.street_address = values.value(forKey: "street_address") as? String ?? ""
                                obj.area = values.value(forKey: "area") as? String ?? ""
                                obj.city = values.value(forKey: "city") as? String ?? ""
                                obj.pincode = values.value(forKey: "pincode") as? String ?? ""
                                obj.state = values.value(forKey: "state") as? String ?? ""
                                obj.type = values.value(forKey: "type") as? String ?? ""
                                obj.addressID = values.value(forKey: "id") as? String ?? ""
                                obj.mobile = values.value(forKey: "mobile") as? String ?? ""
                                
                                obj.flat_no = values.value(forKey: "flat_no") as? String ?? ""
                                obj.apartment_name = values.value(forKey: "apartment_name") as? String ?? ""
                                
                                //addressArray.append(obj)
                                addressSubArray.append(obj)
                                print("addressArray is",addressSubArray)
                            }
                              let adress = AddressModel(addressArray: addressSubArray, headerName: "Saved Addresses")
                              self.savedArray = adress
                            DispatchQueue.main.async {
                                let height = (self.heightRecentList.constant == 0) ? (self.view.frame.height / 2) : self.view.frame.height
                                self.heightSavedList.constant = height
                                self.tblSavedList.isHidden = false
                                self.tblSavedList.reloadData()
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.heightRecentList.constant = self.view.frame.height
                        
                        
                    }
                }
            } catch {
                print("error")
                }
                
            }
    }
}


class Address: NSObject {
    
    var name: String!
    
    var street_address: String!
    
    var city : String!
    
    var area : String!
    
    var state : String!
    
    var type : String!

    var pincode : String!
    
    var addressID: String!
    
    var mobile:String!
    
    var flat_no:String?

    var apartment_name:String?
    
    var latitude_number:String?
    
    var longitude_number:String?
    
} 

extension UIView{

    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?,centerXAxis: NSLayoutXAxisAnchor?,centerYAxis: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero , centerXAdjustment: CGFloat = 0 ,centerYAdjustment: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let centerXAxis = centerXAxis {
            self.centerXAnchor.constraint(equalTo: centerXAxis, constant: centerXAdjustment).isActive = true
        }
        
        if let centerYAxis = centerYAxis {
           self.centerYAnchor.constraint(equalTo: centerYAxis, constant: centerYAdjustment).isActive = true
        }
        
        if size.width != 0 {
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
}
