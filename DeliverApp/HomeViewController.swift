//
//  NewRequestViewController.swift
//  DeliverApp
//
//  Created by User 2 on 4/29/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import ImageSlideshow
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SDWebImage


class HomeViewController: UIViewController  //,GMSPlacePickerViewControllerDelegate
{
    @IBOutlet weak var imagesSlideView: ImageSlideshow!
    
    var imageUrlArray : [SDWebImageSource] = []
    
    @IBOutlet var notesTextView: UILabel!
    
    var notesTextViewStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        AIzaSyB1hYAvrH0twHIDDUFXE3be_UNKoCzdsdY
//        AIzaSyB1hYAvrH0twHIDDUFXE3be_UNKoCzdsdY
        
        let images = [UIImage.init(named: "1") ,UIImage.init(named: "2") ,UIImage.init(named: "3")]
        
        var imageSource: [ImageSource] = []
        for image in images {
            let img = image
            imageSource.append(ImageSource(image:  img!))
        }
        
        notesTextView.text = notesTextViewStr

        
        imagesSlideView.slideshowInterval = 3.0
        imagesSlideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imagesSlideView.contentScaleMode = UIView.ContentMode.scaleAspectFit
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.orange
        imagesSlideView.pageIndicator = pageControl
        
        imagesSlideView.activityIndicator = DefaultActivityIndicator()
        
      //  imagesSlideView.setImageInputs(imageSource)
        
//        imagesSlideView.layer.borderColor = UIColor.orange.cgColor
//
//        imagesSlideView.layer.borderWidth = 1.5
//
//        imagesSlideView.clipsToBounds = true

    ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/home")!, params: [:],viewcontroller: self, finish: finishPost)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        
        self.tabBarController?.navigationItem.title = "Home"
        
    }
    

    func placePicker(_ viewController: GoogleMapPickUPViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(String(describing: place.name))")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
    }
    @IBAction func bookNowBtnAction(_ sender: Any) {
        
        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressBottomSheetViewController") as? BookNowViewController )!

        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func bookLaterBtnAction(_ sender: Any) {
   
    }
    
    func placePickerDidCancel(_ viewController: GoogleMapPickUPViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
 }
    
func finishPost (message:String, data:Data?) -> Void
    {
        
        do {
            
            if let jsonData = data
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] { // as? data type
                    print(json)
                    
 
                    if let restaurantsDict = json["gallery"] as? NSDictionary {

                        for rest in restaurantsDict{
                            
                            let values : NSDictionary = rest.value as! NSDictionary
                            
                            imageUrlArray.append(SDWebImageSource.init(url: URL.init(string: values.value(forKey: "home_img") as! String)!))
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            
                            if let str = json["text"] as? String{
                            
                            self.notesTextViewStr = str
                                
                            }
                           
                            self.imagesSlideView.setImageInputs(self.imageUrlArray)
                            
                            self.notesTextView.text = self.notesTextViewStr
                 
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
     

}
