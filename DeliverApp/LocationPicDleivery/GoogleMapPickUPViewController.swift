//
//  GoogleEnterViewController.swift
//  DeliverApp
//
//  Created by Admin on 7/29/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation 


class GoogleMapPickUPViewController: UIViewController,GMSMapViewDelegate,UITextFieldDelegate{
    
    
    var isPickup = true
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var userId:String = ""
    
    var nameGetInBookNOW:String = ""
    
    var flat_no:String = ""
    
    var apartment_name:String = ""
    
    var street_address:String = ""
    
    var googleAddress:String = ""
    
    
    
    
    var getPickUpMobileNumber:String = " "
    
   
    var txt:String = "Set pickup location"
    
    
    var addressEntry = "G"
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    var coordinate: CLLocationCoordinate2D?
    
    var formattedAddress = ""
    
    var distanceText:String = ""
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentLocationMoveTextfield: UITextField!
    
    
    @IBOutlet weak var houseTextfield: UITextField!
    
    
    @IBOutlet weak var buildingTextField: UITextField!
    
    
    @IBOutlet weak var googleSearchBellowLine: UILabel!
    
    
    @IBOutlet weak var addressLbl: UILabel!
    
   var pickUplocationLimitedPlacesArray = [location]()
    
    
    var locationManager = CLLocationManager()
    var geoCoder:GMSGeocoder!
    var marker:GMSMarker!
    var marker1:GMSMarker!
    var initialcameraposition:GMSCameraPosition!
    
    var sourceLocation : CLLocationCoordinate2D?{
        
        get{
            return AppConstants.pickupLocation?.latitude
        }
    }
    var destinationLocation : CLLocationCoordinate2D?
 
    var player:AVAudioPlayer?

    
override func viewDidLoad() {
        super.viewDidLoad()
    
     print(sourceLocation?.latitude ?? "")
     print(sourceLocation?.longitude ?? "")
     print(destinationLocation?.latitude ?? "")
     print(destinationLocation?.longitude ?? "")
     
    

    if isPickup == true{
        
        textLabel.text = "Set pickup location"
        
    }else{
        
        textLabel.text = "Set delivery location"
 }
    
    
    
    
    currentLocationMoveTextfield.delegate = self
    houseTextfield.delegate = self
    buildingTextField.delegate = self
    nameTextField.delegate = self
    mobileTextField.delegate = self
    
    
    currentLocationMoveTextfield.addBottomBorder()
    houseTextfield.addBottomBorder()
    buildingTextField.addBottomBorder()
    nameTextField.addBottomBorder()
    mobileTextField.addBottomBorder()
    
    
    
    self.geoCoder = GMSGeocoder()
    self.marker = GMSMarker()
    self.marker1 = GMSMarker()
    self.initialcameraposition = GMSCameraPosition()
    
    
    let camera = GMSCameraPosition.camera(withLatitude: 22.857165, longitude: 77.354613, zoom: 4.0)
    mapView.camera = camera
    mapView.delegate = self
    mapView.isMyLocationEnabled = true
    

 //  playSound()
    
    
    self.locationManager.startUpdatingLocation()
    self.locationManager.delegate = self
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
    mapView.isTrafficEnabled = false
    
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
  // Distance filter
    self.locationManager.distanceFilter = 50
    self.marker.title = "Current Location"
    self.marker.map = self.mapView
    
    
  //  setUpNavigationTop()
    
    userId = UserDefaults.standard.value(forKey: "user_id") as! String
    print("PickUp address userId is",userId)
    
    //Accessing this mobile number from phone no viewcontroller userDefaluts
     getPickUpMobileNumber = UserDefaults.standard.value(forKey: "user_mobile") as! String
    
     print("PickUp address Mobile Number is",getPickUpMobileNumber)
    
    
     mobileTextField.text! = getPickUpMobileNumber 
     nameTextField.text = nameGetInBookNOW
     houseTextfield.text = flat_no
     buildingTextField.text = apartment_name
    
    
    if isPickup{
        
      ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/googlelocation")!, params:[:], viewcontroller: self, finish:finishPost1)
        
    }else{
        
         ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/googlelocation")!, params:[:], viewcontroller: self, finish:finishPost1)
    }
       
  }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
 }
    
override func viewWillAppear(_ animated: Bool) {
        
        zoomToMyLocation(lat: coordinate!.latitude, long: coordinate!.longitude, placeName: formattedAddress)
        destinationLocation = CLLocationCoordinate2DMake(coordinate!.latitude, coordinate!.longitude)
        if (sourceLocation != nil) && (destinationLocation != nil){
            self.fetchRoute();
        
      }
    }
func finishPost1 (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] {    // as? data type
                    
                    print(json)
                    
                    
                    
                    if let locationDict = json["location"] as? NSDictionary {
                        
                        for rest in locationDict{
                            
                            
                            let obj = location()
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                            
                            obj.area_id = values.value(forKey:"area_id") as? String
                            obj.area_name = values.value(forKey:"area_name") as? String
                            obj.city_name = values.value(forKey:"city_name") as? String
                            obj.pincode = values.value(forKey:"pincode") as? String
                            
                            pickUplocationLimitedPlacesArray.append(obj)
                            print("locationAndPlaceArray is",pickUplocationLimitedPlacesArray)
                            
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
   
    
    
//MARK - UITextField Delegates
    
let allowedCharacters = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField || textField == currentLocationMoveTextfield || textField == buildingTextField {
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
        
            if string == filtered {
                
                return true
                
            } else {
                
                return false
            }
        }else{
            return true
        }
        
       
    }


func fetchRoute() {
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation!.latitude),\(sourceLocation!.longitude)&destination=\(destinationLocation!.latitude),\(destinationLocation!.longitude)&mode=driving&key=AIzaSyCgp-oF7rarrvQFI8Tm2rzVZ8IrrIdALeQ"
    
  
    print(destinationLocation?.latitude ?? "")
    print(destinationLocation?.longitude ?? "")
    
    DispatchQueue.main.async {
        
        self.mapView.clear()
        self.marker1 = GMSMarker()
        self.marker = GMSMarker()
        self.marker1.map = self.mapView
        self.setMarker1(latitude: self.sourceLocation!.latitude, longitude: self.sourceLocation!.longitude, image: UIImage.init(named:"car")!)
        self.setMarker(latitude: self.destinationLocation!.latitude, longitude: self.destinationLocation!.longitude)
    
    }
  
    
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
 //                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
//                    print(json)
                do{
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    guard let jsonDict = json as? NSDictionary else{return}
                   print(jsonDict)
                   guard let routess = jsonDict.object(forKey: "routes") as? NSArray else{return}
                    if routess.count > 0{
                   guard let elements = routess[0] as? [String: AnyObject] else{return}
                    if let eleArray = elements["legs"] as? NSArray {
                    guard let eleDict = eleArray[0] as? [String: AnyObject] else{return}
                    guard let distanceDict = eleDict["distance"] as? [String: AnyObject] else{return}
                    guard let distance =  distanceDict["text"] as? String else{return}
                    print("Distance: \(distance)")
                    
                    self.distanceText = distance
                    print(self.distanceText)
                    
                    AppConstants.TotalDistance = self.distanceText
                    
                       if let routes = jsonDict["routes"] as? NSArray{
                    OperationQueue.main.addOperation({
                                          DispatchQueue.main.async {
                                              for route in routes
                                              {
                                                  let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                                                  
                                                  let points = routeOverviewPolyline.object(forKey: "points")
                                                  let path = GMSPath.init(fromEncodedPath: points! as! String)
                                                  let polyline = GMSPolyline.init(path: path)
                                                  polyline.strokeWidth = 2
                                                  polyline.strokeColor = UIColor.blue
                                                  let bounds = GMSCoordinateBounds(path: path!)
                                                  self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                                                  polyline.map = self.mapView
                                                  
                                              }
                                          }
                                          
                                      })
                        }
                        }
                    }
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }


func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
    }
    
@IBAction func addressAction(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
       // filter.type = .establishment
        filter.country = "IND"
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: false, completion: nil)

 }
    
func zoomToMyLocation(lat: Double, long: Double, placeName: String) {
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        let marker = GMSMarker(position: position)
//        marker.title = placeName
//        marker.map = mapView
         self.mapView.animate(toLocation: position)
        
         self.mapView.animate(toZoom: 18.0)
    
    
    
       currentLocationMoveTextfield.text = placeName
     print("*********** Pickup Address is ********** ",placeName)
    
    
    
//    let string : String = placeName
//    var characters = string.components(separatedBy: ",")
//    print(characters)
//
//    characters.remove(at: 0)
//    characters.remove(at: 1)
//    characters.remove(at: 2)
//   // characters.remove(at: 3)
//   // characters.remove(at: 7)
//
//    print(characters)
//
//    var stringArray = characters.map { String($0) }
//
//    let string12345 = stringArray.joined(separator: ",")
//
//    print(string12345)

  // currentLocationMoveTextfield.text = string12345

    
//    PickUpsearchedPlaceName = placeName
//    print(PickUpsearchedPlaceName)
    // i given searched place before location textfield
//  addressLbl.text = placeName


 }
    
class location: NSObject {
        var area_id :String?
        var area_name : String?
        var city_name : String?
        var pincode: String?
}
    //1.pincode add params
    //2.area pincode
    //3.pincode == pincode
    
func validateLocation(locPincode: String) -> Bool {  //some times its not call the method
    
        for i in 0..<pickUplocationLimitedPlacesArray .count {
            let dict = pickUplocationLimitedPlacesArray[i]
            print(dict.pincode)
            print(locPincode)
            print("------------------------")
            if dict.pincode == locPincode {
                return true
            }
        
        }
    
    
        return false
        
    }
    
func showAlert(msg: String) {

        let alert = UIAlertController(title: "Warning..!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Select Another Address", style: .default, handler: { (addAction) in

            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            let filter = GMSAutocompleteFilter()

           //filter.type = .establishment
            filter.country = "IND"
            autocompleteController.autocompleteFilter = filter
            self.present(autocompleteController, animated: false, completion: nil)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        self.present(alert, animated: true, completion: nil)

    }
    
    
func AlertMessage(msg:String){
        
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
    
func formValidation()-> Bool {
        
        if nameTextField.text == "" {
           
         self.view!.makeToast("Enter Name", duration: 0.5, position:.bottom)
            return false
            
      }
        else if mobileTextField.text == "" {
            self.view!.makeToast("Enter Mobile Number", duration: 0.5, position:.bottom)
            return false
            
        } else if currentLocationMoveTextfield.text == "" {
            self.view!.makeToast("Please Search Pickup Address", duration: 0.5, position:.bottom)
        
            return false
            
        }  else if houseTextfield.text == "" {
            self.view!.makeToast("Enter House No", duration: 0.5, position:.bottom)
                
            return false
            
        } else if buildingTextField.text == "" {
            
            self.view!.makeToast("Enter Building Name", duration: 0.5, position:.bottom)
            
            return false
            
       }
        
        
        return true
        
 }
    
//func setUpNavigationTop(){    //call this method in viewdidload
//
//    self.navigationItem.title = " Pickup location"
////    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.stop, target: self, action: #selector(callNavigation))
//
//     let  barButtonItem = UIBarButtonItem(image: UIImage(named:"back"),style: .plain,
//    target: self,action: #selector(menuButtonTapped))
//
//    // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
//    self.navigationItem.leftBarButtonItem = barButtonItem
//
//
//    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
//    self.navigationController!.navigationBar.tintColor = .white
//    self.navigationController!.navigationBar.titleTextAttributes = [
//        NSAttributedString.Key.foregroundColor : UIColor.white
//    ]
//
// }

//@objc func callNavigation(){
//
//        self.dismiss(animated: true, completion: nil)
//
//}
    
@objc fileprivate func menuButtonTapped() {
        // body method here
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
func setMarker(latitude: Double, longitude: Double){
        
        DispatchQueue.main.async {
//            let markerView = UIImageView(image: image)
//            markerView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
//            markerView.cornerRadius = 18
//            self.marker.iconView = markerView
            self.marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.marker.map = self.mapView

        }
    }
    
func setMarker1(latitude: Double, longitude: Double, image: UIImage){
        
        DispatchQueue.main.async {
            let markerView = UIImageView(image: image)
            markerView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
            markerView.cornerRadius = 18
            self.marker1.iconView = markerView
            self.marker1.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.marker1.map = self.mapView
            
        }
    }

    
    @IBAction func submitAddressBtnAction(_ sender: Any) {
        
        guard formValidation() == true else {
            
            return
        }
//        var address = (houseTextfield.text ?? "") + " ,"
//            address = address +  (buildingTextField.text ?? "") + " ,"
//            address = address + (currentLocationMoveTextfield.text ?? "")
        
        let address = currentLocationMoveTextfield.text ?? ""
        
   
        
        print(address)
        
        currentLocationMoveTextfield.text = address
        
        if isPickup{
            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/pickgooglesave")!,
            params: ["user_id" : userId ,
                   "address" :address ,
                   "name" :nameTextField.text! ,
                   "mobile" :mobileTextField.text!,
                   "flat_no":houseTextfield.text!,
                                         
           "latitude_number" :destinationLocation?.latitude ?? "",
           "longitude_number" :destinationLocation?.longitude ?? "",

                                                        
        "apartment_name":buildingTextField.text!
                                        ], viewcontroller: self, finish:finishPost)
        }else{
            
            
           print(address)
           currentLocationMoveTextfield.text = address

     ApiService.callPost(url: URL.init(string:
        "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverygooglesave")!,
        params: ["user_id" : userId ,
                "address" :address ,
                "name" :nameTextField.text! ,
                "mobile" :mobileTextField.text!,
                "flat_no":houseTextfield.text!,
                

                "latitude_number" :destinationLocation?.latitude ?? "",
                "longitude_number" :destinationLocation?.longitude ?? "",
                               
                
                
                "apartment_name":buildingTextField.text!],
               viewcontroller: self, finish:finishPost)
        }
    }
    
func finishPost(message:String, data:Data?)->Void{
        
        if let jsonData = data{
          do{
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]{
                        print(json)
                if json["err_msg"] as? String ?? "" == "success" {
                    print("Pickup address from google")
                    DispatchQueue.main.async {
                        self.gotoMainVc()
                        
                   }
                }else{
                
                }
            }else{
                    print("Error")
               }
            }catch(let error) {
                print(error)
               
            }
    }
 }
 func gotoMainVc() {
    
        var address = (houseTextfield.text ?? "") + " ,"
                   address = address +  (buildingTextField.text ?? "") + " ,"
                   address = address + (currentLocationMoveTextfield.text ?? "")
        if isPickup{
            let loc  = LocationModel(latitude: destinationLocation!, address: address, flatno: houseTextfield.text!, appartmentName: buildingTextField.text!)
            
            AppConstants.pickupLocation = loc
            
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            let loc  = LocationModel(latitude: destinationLocation!, address: address, flatno: houseTextfield.text!, appartmentName: buildingTextField.text!)
            
                AppConstants.deliveryLocation = loc
            AppConstants.TotalDistance = distanceText
                                   
                self.navigationController?.popToRootViewController(animated: true)
        }
    }
}


extension GoogleMapPickUPViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        
        
//    guard validateLocation(locPincode: place.name!) else {
//            dismiss(animated: true, completion: nil)
//           // print("pick up order area")
//            print("Unable to delivery to this location, please select different location")
//            self.showAlert(msg: "Unable to delivery to this location, please select different location")
//            return
//     }
//
//
//      // self.locationLabel.text = place.formattedAddress
//
//        getPickUpAddress = place.formattedAddress!
//
//        mapView.clear()
//
//        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        let marker = GMSMarker(position: position)
//        marker.title = place.name
//        marker.map = mapView
//
//        self.mapView.animate(toLocation: position)
//        self.mapView.animate(toZoom: 20.0)
//        dismiss(animated: true, completion: nil)
        
//        https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=YOUR_API_KEY
//
//
//        let path: GMSPath = GMSPath(fromEncodedPath: route)!
//        routePolyline = GMSPolyline(path: path)
//        routePolyline.map = mapView
//
//
//        var bounds = GMSCoordinateBounds()
//
//        for index in 1...path.count() {
//            bounds = bounds.includingCoordinate(path.coordinateAtIndex(index))
//        }
//
//        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds))
        
        zoomToMyLocation(lat: place.coordinate.latitude, long: place.coordinate.longitude, placeName: place.formattedAddress ?? "")
        
        destinationLocation = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        if (sourceLocation != nil) && (destinationLocation != nil){
            self.fetchRoute();
        }
        dismiss(animated: true, completion: nil)
        
    }
    
func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error: ", error.localizedDescription)
    
 }
    
func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: false) {
       
     }
   }
   
func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
    if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
  }
    
}

extension GoogleMapPickUPViewController: CLLocationManagerDelegate {
    
    
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        guard location != nil else {
            
            print("Failed to fetch current location")
            return
    
  }
        
   //    zoomToMyLocation(lat: location?.coordinate.latitude ?? 0.00, long: location?.coordinate.longitude ?? 0.00, placeName: "") //before string had "destination Location" i removed
        
    //Finally stop updating location otherwise it will come again and again in this delegate
    
    //added extra code me
//    var location123 = CLLocation()
//    location123 = locations[0]
//    let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(location123.coordinate.latitude, location123.coordinate.longitude)
//    let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 18.0)
//
//
//    self.mapView.camera = camera
//    self.initialcameraposition = camera
//    self.marker.position = coordinate
    
    
    
    
//    sourceLocation = CLLocationCoordinate2DMake(location123.coordinate.latitude, location123.coordinate.longitude)
//    if (sourceLocation != nil) && (destinationLocation != nil) && CLLocationCoordinate2DIsValid(sourceLocation) && CLLocationCoordinate2DIsValid(destinationLocation){
//        if location123.distance(from: CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)) >= 10{
//            self.fetchRoute();
//        }else{
//          // print("destinationReached")
//
//            playSound()
//
//
//           // showAlert(message: "Your destination Reached")
//
//
//        }
        
        
    }
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
       print(error)
   
    }

    
//    func showAlert(message:String){
//
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
//

//    }
    
func playSound() {
    
        guard let url = Bundle.main.url(forResource: "reached", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    
}










