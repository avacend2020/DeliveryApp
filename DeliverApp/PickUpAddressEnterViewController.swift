//
//  AddressViewController.swift
//  DeliverApp
//
//  Created by User 2 on 5/7/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import TCPickerView

class PickUpAddressEnterViewController: UIViewController {
    
     var userId:String = ""
     var getMobileNumber:String = ""
    
    
     var  pickupOptionSelected:String = ""
     var passgetAddressId:String = ""
    
  
    

    @IBOutlet var addressSengment: UISegmentedControl!
    
    @IBOutlet var streetFiled: UITextField!
    
    @IBOutlet var flatNamefield: UITextField!
    
    @IBOutlet var pincodeField: UITextField!
    
    @IBOutlet var cityBtn: UIButton!
    
    @IBOutlet var areaBtn: UIButton!
    
    
    @IBOutlet var stateField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    var imagesArrray : Array<UIImage>?
    
    var titleArray : Array<String>!
    
    var locationArray : [location] = []
    
    var buttonNameArray : [String] = []

    @IBOutlet var plainView: UIView!

    @IBOutlet var cityTableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
    
    var locationObj: Address?
    
    var cityIsSelected : Bool!
//    var area = ""
//    var city = ""
    
    var SelectedIndex : Int = 999
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  setupNavigation()
        
      //  addNavigationBarButton(imageName: "backWhite", direction: .left)
        
        
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        
        getMobileNumber = UserDefaults.standard.value(forKey:"user_mobile") as! String
        print("get Mobile Number is",getMobileNumber)
        
        mobileTextField.text = getMobileNumber
        
        
        addressSengment.selectedSegmentIndex = 1
        
        if let obj = locationObj { 
            
          // valuesSetUp(obj: obj)
         
        }
        
        plainView.isHidden = true
        
        plainView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        imagesArrray = [UIImage.init(named: "homeAddress") , UIImage.init(named: "manual") ,UIImage.init(named: "others")] as? Array<UIImage>
       
        titleArray = ["Home","Office", #"Other location"#]
        
        
        
        
        cityBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        cityBtn.layer.borderWidth = 0.5
        
        cityBtn.clipsToBounds = true
        
        areaBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        areaBtn.layer.borderWidth = 0.5
        
        areaBtn.clipsToBounds = true
        
        
        cityTableView.tableHeaderView = headerView
        
        
        
        
        ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/location")!, params: [:],viewcontroller: self, finish: finishPost)
        
       

        
    }
    
    @IBAction func addressSegmantAction(_ sender: Any) {
        
        
        if addressSengment.selectedSegmentIndex == 1{
            
            
            
        }else{
            
            self.dismiss(animated:true, completion: nil)
        }
    }
    
    
//func addNavigationBarButton(imageName:String,direction:direction){  //call in this method in viewDidload 
//
//        self.title = "PickUp Address"
//        self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
//        self.navigationController!.navigationBar.tintColor = .white
//        self.navigationController!.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.white
//        ]
//
//        var image = UIImage(named:imageName)
//        image = image?.withRenderingMode(.alwaysOriginal)
//        switch direction {
//        case .left:
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(goBack))
//        case .right:
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(goBack))
//
//        }
//    }
//
//@objc func goBack() {
//        // navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
//
//    }
//enum direction {
//        case right
//        case left
//}

    
    
    
//func setupNavigation(){
//
//        self.title = "Address"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"←", style: .done, target: self, action: #selector(menuAction))
//
//        self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
//        self.navigationController!.navigationBar.tintColor = .white
//        self.navigationController!.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.white
//        ]
//
//
//    }
//
// @objc func menuAction(){
//
//        self.dismiss(animated: true, completion: nil)
//
//    }
    
@IBAction func backAction(_ sender: Any) {
        
    self.dismiss(animated:true, completion: nil) // before it have into button Action
        
 }
    
func finishPost (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    
                    print(json)
                    
                    
                    if let restaurantsDict = json["location"] as? NSDictionary {
                        
                        for rest in restaurantsDict{
                            
                            
                            let obj = location()
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                        
                            obj.ID = values.value(forKey: "ID") as? String
                            obj.area_id = values.value(forKey: "area_id") as? String
                            obj.area_name = values.value(forKey: "area_name") as? String
                            obj.name = values.value(forKey: "name") as? String
                            
                            locationArray.append(obj)
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
    
func proceedFinishPost (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    
                    print(json)
                    
                    let getAddressId = json["id"] as! String
                    print("getAddressId is ",getAddressId)
                    passgetAddressId = getAddressId
                    print("passgetAddressId is",passgetAddressId)
                    
                    
//                    self.city = ""
//                    self.area = ""
                    
                }
                DispatchQueue.main.async {
                    
                    
                    
                    let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlanYourPickupViewController") as? PlanYourPickupViewController )!
                   
                    vc.fromID = 2 
                    
                    vc.address_id = self.passgetAddressId
                    self.present(vc, animated: true, completion: nil)
                    
                    // self.dismiss(animated: true, completion: nil)
                    
                }
                
            }else{
                
                DispatchQueue.main.async {
                    
                   
                }
                
            }
        } catch {
            
            print("error")
            
        }
    }
    
    @IBAction func cityBtnAction(_ sender: Any) {
        
        buttonNameArray.removeAll()
        
        cityIsSelected = true
        
        for locationName in locationArray{
            
            buttonNameArray.append(locationName.name ?? "")
            
        }
        
        buttonNameArray = buttonNameArray.removingDuplicates()
        
        cityTableView.reloadData()
        
        areaBtn.setTitle("Area", for: .normal)
        
         plainView.isHidden = false
    
    }
    
func showAlert(msg: String) {
        
        let alert = UIAlertController(title: "Alert", message:msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
 }
    
func formValidation() -> Bool {
        
        if flatNamefield.text == "" {
            
            showAlert(msg: "Enter Firstname")
            return false
            
        }else if streetFiled.text == "" {
            showAlert(msg: "Enter street")
            return false
            
        }else if pincodeField.text == "" {
            showAlert(msg: "Enter pincode")
            return false
            
        }
        
        return true
        
        
    }
    

    
    @IBAction func proceedBtnAction(_ sender: Any) {
        
        
        if let area = areaBtn.titleLabel?.text , let city = cityBtn.titleLabel?.text {
            
            
            let cityArray = locationArray.filter({ $0.name == city})
            
            
            let areaArray = locationArray.filter({ $0.area_name == area})
            
            guard formValidation() == true else {
                return

            }
            
            
            let param = ["user_id" :userId , "name" : flatNamefield.text! , "address" : streetFiled.text!,"pincode" : pincodeField.text! , "city" : cityArray[0].ID ?? "0" ,"area" : areaArray[0].area_id ?? "0"  , "state" : stateField.text!,"mobile" :mobileTextField.text! , "type" :pickupOptionSelected]
            print(param)
            
            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/recent_address")!, params: param,viewcontroller: self, finish: proceedFinishPost)
        }
        
        
}
    @IBAction func dissmissButton(_ sender: Any) {
        
        
        plainView.isHidden = true
        
    }
    @IBAction func areaBtnAction(_ sender: Any) {
        
        
        if cityBtn.titleLabel?.text! != "City"{
          
            let array = locationArray.filter({ $0.name == cityBtn.titleLabel?.text!})
        
             buttonNameArray.removeAll()
        
        for locationName in array {
            
            buttonNameArray.append(locationName.area_name ?? "")
            
        }
        
        buttonNameArray = buttonNameArray.removingDuplicates()
        
        cityTableView.reloadData()
        plainView.isHidden = false
            
        cityIsSelected = false
            
        }else{
            
            print("error")
        }
    }
    
    func valuesSetUp(obj : Address) {
        
            streetFiled.text = obj.street_address
        
            flatNamefield.text = obj.name
        
            pincodeField.text = obj.pincode
        
            cityBtn.setTitle(obj.city, for: .normal)
        
            areaBtn.setTitle(obj.area, for: .normal)
        
            stateField.text = obj.state
        
            mobileTextField.text = obj.mobile
        
    }
    
}




extension PickUpAddressEnterViewController : UICollectionViewDataSource , UICollectionViewDelegate ,UITextFieldDelegate {
    
    
func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
 }
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  imagesArrray?.count ?? 3
    
 }
    
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveCell", for: indexPath)
        
        // Configure the cell
       // cell.backgroundColor = UIColor.white
    
       cell.layer.borderColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1).cgColor
    
     cell.layer.cornerRadius = 10
     cell.layer.borderWidth = 1
        
        let imagesView = cell.viewWithTag(1) as! UIImageView
        
        imagesView.image = imagesArrray?[indexPath.row]
        
    let titleLabel = cell.viewWithTag(2) as! UILabel
        
     titleLabel.text = titleArray![indexPath.row]
    
    
    if SelectedIndex == indexPath.item{
        
        cell.backgroundColor = UIColor.lightGray
//        cell.layer.borderColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1).cgColor
      //  titleLabel.textColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    }
    else{
        
        cell.backgroundColor = UIColor.white
    }


        return cell
}
    
    
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       // selectedImage = cellImages[indexPath.row] as String
        let selectedLabels = titleArray[indexPath.row]

        print(selectedLabels)

        pickupOptionSelected = selectedLabels
        print("did select option",pickupOptionSelected)
    
    SelectedIndex = indexPath.item
//     resultLabel.text = "pickup option selected" + titleArray[indexPath.item] + "\n" + "Selected Item:" + "\(indexPath.item)"
    collectionView.reloadData()

 }
    
//func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//    let selectedLabels = titleArray[indexPath.row]
//
//    print(selectedLabels)
//
//    pickupOptionSelected = selectedLabels
//    print("did Deselect option",pickupOptionSelected)
//
// }
    
//func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor = UIColor.lightGray
//
//  }

}

extension PickUpAddressEnterViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        plainView.isHidden = true
        
        if cityIsSelected == false  {
            
            areaBtn.setTitle(buttonNameArray[indexPath.row], for: .normal)
          //  area = buttonNameArray[indexPath.row]
            
        }else{
            
             cityBtn.setTitle(buttonNameArray[indexPath.row], for: .normal)
           // cityBtn = buttonNameArray[indexPath.row]
 
        }
       
        
    }
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonNameArray.count
    
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
        
        cell.textLabel?.text = buttonNameArray[indexPath.row]
     
        return cell
 }
    
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.frame  = CGRect.init(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: tableView.contentSize.height)
        
    }
   
}
class location: NSObject {
    
    var ID: String?
    
    var area_id: String?
    
    var area_name : String?
    
    var name : String?
}
