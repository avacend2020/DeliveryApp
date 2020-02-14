//
//  ViewController.swift
//  DeliverApp
//
//  Created by User 2 on 4/24/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class ViewController: UIViewController { 

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var baseSlideImage: ImageSlideshow!
    
    var imageUrlArray : [SDWebImageSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
               navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        let images = [UIImage.init(named: "main-delivery") ,UIImage.init(named: "2") ,UIImage.init(named: "3")]
        
        var imageSource: [ImageSource] = []
        
        for image in images {
            let img = image
            imageSource.append(ImageSource(image:  img!))
        }
    
        
        baseSlideImage.slideshowInterval = 3.0
        baseSlideImage.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        baseSlideImage.contentScaleMode = UIView.ContentMode.scaleAspectFit
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        baseSlideImage.pageIndicator = pageControl
       
        baseSlideImage.activityIndicator = DefaultActivityIndicator()
       
       //baseSlideImage.setImageInputs(imageSource)
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
        loginButton.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        signUpButton.clipsToBounds = true 
        
        ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/loading")!, params: [:],viewcontroller: self, finish: finishPost)
        // Do any additional setup after loading the view.
        print("test test tesr----------------------------------------------")
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/test")!, params: ["name" :"ios" , "email" :"test@gmail.com" , "phone" :"9790876470"],viewcontroller: self, finish:finishPost)
     
    }

    
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhoneNumberViewController") as? PhoneNumberViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhoneNumberViewController") as? PhoneNumberViewController
        self.navigationController?.pushViewController(vc!, animated: true)
   
    }
    @IBAction func SignUpButtonAction(_ sender: Any) {
        
        let signUpViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController_ID") as! SignUpViewController
        self.navigationController?.pushViewController(signUpViewController, animated: true)
        
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
                            
                           self.baseSlideImage.setImageInputs(self.imageUrlArray)
                            
                            
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

