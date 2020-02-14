//
//  GoogleMapDeliveryViewController.swift
//  DeliverApp
//
//  Created by Admin on 7/31/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import AVFoundation

import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation

class GoogleMapDeliveryViewController: UIViewController,GMSMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate {
    
    
    var userId:String = ""
    
    var getDeliveryMobileNumber:String = ""
    
    
    var getDeliveryAddress:String = ""
    
                                    // Delivery address are below onely
                                   //Adyar,kodambakkam,porur,T.nager
    
    var administrativeArea: String! //add for extra varable declaration
    
  
    @IBOutlet weak var currentLocationMoveTextfield: UITextField!
    
    
    @IBOutlet weak var houseTextfield: UITextField!
    
    
    @IBOutlet weak var buildingTextField: UITextField!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
  
    var DeliverylocationLimitedPlacesArray = [location]()
    
   
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var geoCoder:GMSGeocoder!
    var marker:GMSMarker!
    var marker1:GMSMarker!
    
    var initialcameraposition:GMSCameraPosition!
    
    var sourceLocations : CLLocationCoordinate2D!
    var destinationLocations : CLLocationCoordinate2D!
    
    var player: AVAudioPlayer?
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
     // playSound()
   
    
    currentLocationMoveTextfield.delegate = self
   //houseTextfield.delegate = self
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
//    mapView.isMyLocationEnabled = true
    
    self.locationManager.delegate = self
    self.locationManager.delegate = self
    self.locationManager.delegate = self
    
    
    self.locationManager.startUpdatingLocation()
    self.locationManager.delegate = self  
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
    mapView.isTrafficEnabled = false
     self.locationManager.delegate = self
     self.locationManager.delegate = self
     self.locationManager.delegate = self
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    self.locationManager.distanceFilter = 50
    self.marker.title = "Current Location"
    self.marker.map = self.mapView
    
    
    
                                                   //  13.0213,80.2231
     // static i given 
    //self.sourceLocations = CLLocationCoordinate2DMake(13.0418,80.2341)
    
        
        setNavigationTop()
        
        userId = UserDefaults.standard.value(forKey:"user_id") as! String
        print("delivery address userId is",userId)
        
        getDeliveryMobileNumber = UserDefaults.standard.value(forKey:"user_mobile") as! String
        print("delivery mobile number is",getDeliveryMobileNumber)
        
        mobileTextField.text! = getDeliveryMobileNumber
        
         ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/googlelocation")!, params:[:], viewcontroller: self, finish:finishPost1)
        
    }
    
func setNavigationTop(){          //call this method in viewDidLoad

    self.navigationItem.title = " Delivery location"
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(callNavigation))
    
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(menuButtonTapped))
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem
    
   self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    self.navigationController!.navigationBar.tintColor = .white
    self.navigationController!.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]
    
 }
//    https://stackoverflow.com/questions/39768600/how-to-programmatically-set-action-for-barbuttonitem-in-swift-3
// Private action
@objc fileprivate func menuButtonTapped() {
// body method here
    
    self.dismiss(animated: true, completion: nil)
    
    
 }

//@objc func callNavigation(){
//
//    self.dismiss(animated: true, completion: nil)
//
//}
//
    
func finishPost1 (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    
                    print(json)
                    
                    
                    
                    if let locationDict = json["location"] as? NSDictionary {
                        
                        for rest in locationDict{
                            
                            
                            let obj = location()
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                            
                            obj.area_id = values.value(forKey:"area_id") as? String
                            obj.area_name = values.value(forKey:"area_name") as? String
                            obj.city_name = values.value(forKey:"city_name") as? String
                            obj.pincode = values.value(forKey:"pincode") as? String
                            
                            DeliverylocationLimitedPlacesArray.append(obj)
                            print("locationAndPlaceArray is",DeliverylocationLimitedPlacesArray)
                            
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
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocations.latitude),\(sourceLocations.longitude)&destination=\(destinationLocations.latitude),\(destinationLocations.longitude)&mode=driving&key=AIzaSyCgp-oF7rarrvQFI8Tm2rzVZ8IrrIdALeQ"
        
        DispatchQueue.main.async {
            self.mapView.clear()
            self.marker1 = GMSMarker()
            self.marker = GMSMarker()
            self.marker1.map = self.mapView
            self.setMarker1(latitude: self.sourceLocations.latitude, longitude: self.sourceLocations.longitude, image: UIImage.init(named:"car")!)
            self.setMarker(latitude: self.destinationLocations.latitude, longitude: self.destinationLocations.longitude)
        }
        
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    
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
        filter.type = .establishment
        filter.country = "IND"
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: false, completion: nil)
        
    }
func zoomToMyLocation(lat: Double, long: Double, placeName: String) {
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.title = placeName
        marker.map = mapView
        self.mapView.animate(toLocation: position)
        self.mapView.animate(toZoom: 18.0)
        
      //  locationLabel.text = placeName
    
    currentLocationMoveTextfield.text = placeName  // i given searched place before location textfield
    print("*********** Delivery Address is ********** ",placeName)
    
 }
    
class location: NSObject {
        var area_id :String?
        var area_name : String?
        var city_name : String?
        var pincode:String?
    
    }
    
func validateLocation(locPincode: String) -> Bool {
        
        for i in 0..<DeliverylocationLimitedPlacesArray .count {
            let dict = DeliverylocationLimitedPlacesArray[i]
            print(dict.pincode)
            print(locPincode)
            
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
            filter.type = .establishment
            filter.country = "IND"
            filter.type = GMSPlacesAutocompleteTypeFilter.city
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
    
func formValidation()->Bool{
        
        if nameTextField.text == "" {
            AlertMessage(msg: "Enter Name")
            return false
        }
        else if mobileTextField.text == "" {
            
            AlertMessage(msg: "Enter Mobile")
            return false
            
        } else if currentLocationMoveTextfield.text == "" {
            
            AlertMessage(msg: "Search Delivery Address")
            return false
        } else if houseTextfield.text == "" {
            
            AlertMessage(msg: "Enter House No")
            return false
        } else if buildingTextField.text == "" {
            
            AlertMessage(msg: "Enter Building Name")
            return false
            
    }  
        
      return true
        
 }
    
    
    @IBAction func submitDeliveryButton(_ sender: Any) {
        
//        guard formValidation() == true else {
//            return
//        }
        
         ApiService.callPost(url: URL.init(string:
           "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/deliverygooglesave")!, params: ["user_id" : userId , "address" :getDeliveryAddress ,"name" :nameTextField.text! , "mobile" :mobileTextField.text!], viewcontroller: self, finish:finishPost)
        
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
    
    
func finishPost(message:String, data:Data?)->Void{
        
        if let jsonData = data
        {
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                
                
                
                
                if json["err_msg"] as? String ?? "" == "success" {
                    
                    print("Delivery address from google")
                    
                    
                    //bellow one passing views previous code floow

//                    let otpVc = storyboard?.instantiateViewController(withIdentifier: "DeliverySummaryViewController") as! DeliverySummaryViewController
                    
//
                    
        let otpVc = storyboard?.instantiateViewController(withIdentifier: "PlanYourPickupViewController") as! PlanYourPickupViewController
                    
      DispatchQueue.main.async {
                        self.present(otpVc, animated: true, completion: nil)
                    }
                    
                }else{
                    
                }
            }
        }
        
    }
    
 }

extension GoogleMapDeliveryViewController: GMSAutocompleteViewControllerDelegate {
    
func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        
//        guard validateLocation(locPincode: place.name!) else {
//            dismiss(animated: true, completion: nil)
//            print("Unable to delivery to this location, please select different location")
//            self.showAlert(msg: "Unable to delivery to this location, please select different location")
//
//            return
//
// }
//
//
//      //  self.locationLabel.text = place.formattedAddress
//
//
//        getDeliveryAddress = place.formattedAddress!
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
        
        
//        zoomToMyLocation(lat: place.coordinate.latitude, long: place.coordinate.longitude, placeName: place.formattedAddress ?? "")
//
//        destinationLocation=CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
//        if (sourceLocation != nil) && (destinationLocation != nil) && CLLocationCoordinate2DIsValid(sourceLocation) && CLLocationCoordinate2DIsValid(destinationLocation){
//            self.fetchRoute();
//
//        dismiss(animated: true, completion: nil)
//
//    }
//}
        zoomToMyLocation(lat: place.coordinate.latitude, long: place.coordinate.longitude, placeName: place.formattedAddress ?? "")
        
        destinationLocations=CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        if (sourceLocations != nil) && (destinationLocations != nil) && CLLocationCoordinate2DIsValid(sourceLocations) && CLLocationCoordinate2DIsValid(destinationLocations){
            self.fetchRoute();
        }else{
            print("sdfgh") //its came else condition 
        }
        
        dismiss(animated: true, completion: nil)   //pick up working fine
        
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
    
    
    
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        guard location != nil else {
            print("Failed to fetch current location")
            return
        }
        
        zoomToMyLocation(lat: location?.coordinate.latitude ?? 0.00, long: location?.coordinate.longitude ?? 0.00, placeName: "") // //before string had "current location" i removed
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        
        //added extra code me
        var location123 = CLLocation()
        location123 = locations[0]
        let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(location123.coordinate.latitude, location123.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 18.0)
        
        self.mapView.camera = camera
        self.initialcameraposition = camera
       // self.marker.position = coordinate
    
    
    
    sourceLocations = CLLocationCoordinate2DMake(location123.coordinate.latitude, location123.coordinate.longitude)
    if (sourceLocations != nil) && (destinationLocations != nil) && CLLocationCoordinate2DIsValid(sourceLocations) && CLLocationCoordinate2DIsValid(destinationLocations){
        if location123.distance(from: CLLocation(latitude: destinationLocations.latitude, longitude: destinationLocations.longitude)) >= 10{
            self.fetchRoute();
        }else{
            // print("destinationReached")
            
           // showAlert(message: "Your destination Reached")
            
          playSound()
            
            
        }
        
        
    }
    //    self.locationManager.stopUpdatingLocation()
    
    }
    
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error",error)
        
    }
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






