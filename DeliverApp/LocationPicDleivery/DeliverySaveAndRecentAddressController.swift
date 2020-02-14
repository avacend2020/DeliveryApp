
//  DeliverySaveAndRecentAddressControllerViewController.swift
//  DeliverApp
//  Created by Admin on 7/19/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class DeliverySaveAndRecentAddressController: UIViewController,AddressDelegate {
    
    var userId:String = ""
    var vDelegate:CommentsDelegate? = nil
    @IBOutlet var selectedcollectionView: UICollectionView!
    @IBOutlet var addressSegmentcontrol: UISegmentedControl!
    @IBOutlet var addressTableView: UITableView!
    var imagesArrray : Array<UIImage>?
    
    var titleArray : Array<String>?
    
    var buttonNameArray : Array<String>?
    
    var addressArray = [AddressName]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // setupNavigation() 
        
        
//        let gradientLayerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = gradientLayerView.bounds
//        // gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//
//        gradient.colors = [UIColor(red: 35/255, green: 151/255, blue: 215/255, alpha: 1).cgColor, UIColor(red: 111/255, green: 94/255, blue: 211/255, alpha: 1).cgColor]
//
//        //  gradient.locations = [0.0, 0.35]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
//        gradientLayerView.layer.insertSublayer(gradient, at: 0)
//        self.view.layer.insertSublayer(gradientLayerView.layer, at: 0)
//
        
        //set collectionview background color
      //  self.selectedcollectionView.backgroundColor = UIColor.clear
        
        
        addNavigationBarButton(imageName:"backWhite", direction:.left)
        
        
        addressArray.reverse()
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        
        print("myUserid is",userId)
        
        
        imagesArrray = [UIImage.init(named: "location") , UIImage.init(named: "manual")] as? Array<UIImage>
        
        buttonNameArray = ["Google","Manual"]
        
        titleArray = ["Find the google Location","Manual location"]
        
        
        addressTableView.estimatedRowHeight = 44
        addressTableView.rowHeight = UITableView.automaticDimension
        
        
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/recent_deliveryaddresslist")!, params: ["user_id" :userId],viewcontroller: self, finish: finishPost)
        
        
 }
    
    
    
//func setupNavigation(){
//
//    self.title = "Address"
//
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"", style: .done, target: self, action: #selector(menuAction))
//
////        let yourBackImage = UIImage(named: "back")
////        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
////        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//      // self.navigationController?.navigationBar.backItem?.title = "Custom"
//
//
//    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
//    self.navigationController!.navigationBar.tintColor = .white
//    self.navigationController!.navigationBar.titleTextAttributes = [
//        NSAttributedString.Key.foregroundColor : UIColor.white
//    ]
//
//}
//
// @objc func menuAction(){
//
//        self.dismiss(animated: true, completion: nil)
//
//}
    
    
func addNavigationBarButton(imageName:String,direction:direction){
    
    self.title = "Address"
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
       // navigationController?.popViewController(animated: true)
      self.dismiss(animated: true, completion: nil)

 }
    
    enum direction {
        case right
        case left
    }
    
    

    
    
    
//@IBAction func backAction(_ sender: Any) {
//
//        self.dismiss(animated: true, completion: nil)
//    }
    
func finishPost (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    
                    print(json) 
                    
//                    let getDeliveryId = json["id"] as? String ?? ""
//                    print("getDeliveryId is ",getDeliveryId)

                    
                    
                    
                    //                    ["success": 1, "recent_address": [
                    //                        {
                    //                            name = eee;
                    //                            pincode = 3443;
                    //                            state = Tamilnadu;
                    //                            "street_address" = eee;
                    //                            type = Home;
                    //                        },
                    //                        {
                    //                            name = eee;
                    //                            pincode = 3443;
                    //                            state = Tamilnadu;
                    //                            "street_address" = eee;
                    //                            type = Home;
                    //                        }]
                    
                    
                    
                    
                    
                    addressArray.removeAll()
                    if let restaurantsDict = json["recent_address"] as? NSDictionary {
                        
                        for rest in restaurantsDict{
                            let obj = AddressName()
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                            print(values)
                            obj.name = values.value(forKey: "name") as? String ?? ""
                            obj.street_address = values.value(forKey: "street_address") as? String ?? ""
                            obj.area = values.value(forKey: "area") as? String ?? ""
                            obj.city = values.value(forKey: "city") as? String ?? ""
                            
                            obj.pincode = values.value(forKey: "pincode") as? String ?? ""
                            obj.state = values.value(forKey: "state") as? String ?? ""
                            obj.type = values.value(forKey: "type") as? String ?? ""
                            obj.mobile = values.value(forKey:"mobile") as? String ?? ""
                            obj.ID = values.value(forKey: "id") as? String ?? ""
                            
                            // addressArray.append(obj)
                            addressArray.append(obj)
                            print("addressArray is",addressArray)
                            addressArray.reverse()
                            
                    }
                        
                        DispatchQueue.main.async {
                            
                            self.addressArray.reverse()
                            self.addressTableView.reloadData()
                            
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
    
    
@IBAction func addressSegmant(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/recent_deliveryaddresslist")!, params: ["user_id" :userId],viewcontroller: self, finish: finishPost)
            
        }else{
            
            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverysave_addresslist")!, params: ["user_id" :userId],viewcontroller: self, finish: finishPost)
            
        }
    }
    
 }

extension DeliverySaveAndRecentAddressController : UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArrray?.count ?? 2
    
 }
    
 func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    
        return 1
    }
    
    
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
    // Configure the cell clear color i given to the collection view cell its came over all view Gredient color
      //  cell.backgroundColor = UIColor.clear
    cell.contentView.backgroundColor = UIColor.clear
        
        let imagesView = cell.viewWithTag(3) as! UIImageView
        
        imagesView.image = imagesArrray?[indexPath.row]
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        
        titleLabel.text = titleArray?[indexPath.row]
        
        let subTextLabel = cell.viewWithTag(4) as! UILabel
        
        subTextLabel.text = buttonNameArray?[indexPath.row]
        
        
        
        return cell
    }
    
    
//func pushView() {
//
//
//    let controller =  self.storyboard!.instantiateViewController(withIdentifier: "GoogleMapDeliveryViewController") as! GoogleMapDeliveryViewController
//
//        self.navigationController?.pushViewController(controller, animated:true)
//
//    }
    
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            
              // pushView()
            
            // present controller code
            
        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GoogleMapDeliveryViewController") as? GoogleMapDeliveryViewController)!

            let nav = UINavigationController(rootViewController: vc)

            DispatchQueue.main.async {

            self.present(nav, animated: true, completion: nil)

     
     }
            
           
            
            //push controller code.
            
            
//            let vc = storyboard?.instantiateViewController(withIdentifier: "GoogleMapDeliveryViewController") as! GoogleMapDeliveryViewController
//
//             self.navigationController?.pushViewController(vc, animated: true)


        }else{
            
            let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryAddressEnterViewController") as? DeliveryAddressEnterViewController )!
            
           vc.addDelegate = self
            
         //   let navigation = UINavigationController(rootViewController: vc)
            
            
            self.present(vc, animated: true, completion: nil)
            
        }
}
    
func addressData(addrs: String,ID:String) {
        
    print("*************************")

    print(addrs,ID)
//    vDelegate?.commentsData(address: addrs, from: "2")
//
//    self.dismiss(animated: true, completion: nil)
    
    
    vDelegate!.commentsData(address:addrs, from: "1", ID:ID)
    
    self.presentingViewController?.dismiss(animated: true, completion: nil)

  }
    

}


extension DeliverySaveAndRecentAddressController : UITableViewDelegate , UITableViewDataSource{
    
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let addressData = addressArray[indexPath.row]
        
        let address = addressData.area + "," + addressData.street_address + "," + addressData.state + "," + addressData.mobile + "," + addressData.name + "," + addressData.pincode
        
        
       
    vDelegate!.commentsData(address:address, from: "1", ID: addressData.ID)
        
    self.dismiss(animated: true, completion: nil)
        
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "DeliveryMainAddressViewController") as! DeliveryMainAddressViewController
//
//        let indexPath = tableView.indexPathForSelectedRow!
//      //  let currentCell = tableView.cellForRow(at: indexPath)! as! RecentLocationCell
//
//
//        vc.deliveryData = addressArray[indexPath.row]
//
//        vc.fromData = 1
        
      //  vc.locationObj = addressArray[indexPath.row]
        
        
        
      //  let navBar = UINavigationController(rootViewController: vc)
        
      //  self.present(navBar, animated: true, completion: nil)
        
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationCell_ID") as! RecentLocationCell
        
        let obj = addressArray[indexPath.row]
        // let AddressLabel = cell.viewWithTag(2) as! UI
        
        
//        let name = obj.name ?? ""
//        let street = obj.street_address ?? ""
//        let area = obj.area ?? ""
//        let city = obj.city ?? ""
//        let pincode = obj.pincode ?? ""
//        let State = obj.state ?? ""
//        let mobile = obj.mobile ?? ""
        
        
        
//        cell.locationLbl.text = "Name: \(name)\nStreet: \(street)\nArea: \(area)\nCity: \(city)\nState: \(state)\nPincode: \(pincode)\nmobile:\(mobile)"
        
        

//        cell.locationLbl.text = "\(name),\(street),\(city),\(State),\(area), \(mobile), \(pincode)".replacingOccurrences(of: ",,,,", with: ",").replacingOccurrences(of: ",,,", with: ",").replacingOccurrences(of: ",,", with: ",").trimmingCharacters(in: .init(charactersIn: ","))
//
        
        
        let nameS = obj.name
        let streetS = obj.street_address != "" ? ("," + obj.street_address) : ""
        let cityS = obj.city != "" ? ( "," + obj.city) : ""
        let areaS = obj.area != "" ? ( "," + obj.area) : ""
        let stateS = obj.state != "" ? ("," + obj.state) : ""
        let pincode = obj.pincode != "" ? ("," + obj.pincode) : ""
        let MobileS = obj.mobile != "" ? ("," + obj.mobile) : ""
        
        
        cell.locationLbl.text = "\(nameS!)\(streetS)\(cityS)\(stateS)\(areaS)\(MobileS) \(pincode)"
        
        

        
        // let imagesView = cell.viewWithTag(1) as! UIImageView
        
        
        if obj.type == "home"{
            
            cell.locationImage.image = UIImage.init(named: "homeAddress")
            
            //imagesView.image = UIImage.init(named: "homeAddress")
            
        }else  if obj.type == "office"{
            
            cell.locationImage.image = UIImage.init(named: "Manual")
            
            // imagesView.image = UIImage.init(named: "manual")
            
        }else{
            
            cell.locationImage.image = UIImage.init(named: "others")
            
            // imagesView.image = UIImage.init(named: "others")
            
        }
        
        
        
        return cell
    }
    
}

