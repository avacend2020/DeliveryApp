//
//  verifyOtpViewController.swift
//  DeliverApp
//
//  Created by User 2 on 4/25/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import SVPinView

class verifyOtpViewController: UIViewController {

    @IBOutlet weak var otpDisplaylbl: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var userId: String = ""
    var otpStr: String = ""
    var otpgettingservice:String = ""
    
    var mobileNo: String = ""
    

override func viewDidLoad() {
        super.viewDidLoad()
        
       otpDisplaylbl.text = mobileNo
       print("myDisplay mobile no", otpDisplaylbl) 
        
      
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/otpgenerator")!, params: ["userid" : userId,"mobile":mobileNo], viewcontroller: self, finish:finishPost)
        
        
        //add this down parameter in above parameter otp generator in different mobile no
        
        
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 5
        pinView.textColor = UIColor.black
        pinView.shouldSecureText = true
        pinView.style = .box
        pinView.borderLineColor = UIColor.lightGray
        pinView.activeBorderLineColor = UIColor.orange
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 3
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = UIView.init()
        pinView.placeholder = "******"
        pinView.becomeFirstResponderAtIndex = 0
        
        
        
        pinView.didFinishCallback = { pin in
            
            print("The pin entered is \(pin)")
            self.otpStr = pin
            self.loginBtn.isHidden = false
            
        }
    
        
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        
        loginBtn.clipsToBounds = true
        
    }
    
func finishPost(message:String,data:Data?)->Void{
        
        if let jsonData = data {
            
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] {  // as? data type
                
                print("otp generator is" ,json)
                
                let otpgeneator = json["otp"] as! String
                
                otpgettingservice = otpgeneator
            }
        }
    }

    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
 }
    @IBAction func loginBtnAction(_ sender: Any) {
        
        
      if otpStr == otpgettingservice
        {
           // print("success")
            
            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/otpcheck")!, params: ["userid" : userId], viewcontroller: self, finish:finishPost1)

        }else{
            
             alertShow(message: "Your Entered Inavalid OTP")
            
          
        }
        
 }
    
func finishPost1(message:String,data:Data?)->Void{
        
        if let jsonData = data {
            
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print("otpcheck is" , json)
                
                                if json["success"] as? String ?? "" == "true" {
                                    print(" Your OTP Success")
                                    //save user deta here
                                    let userfName = json["userfirstname"] as? String ?? ""
                                    let userLname = json["userlastname"] as? String ?? ""
                                    let userMail = json["useremail"] as? String ?? ""
                                    let userphNo = json["usermobile"] as? String ?? ""
                                    let userID = json["userid"] as? String ?? ""
                                    let userProfileImg = json["userImg"] as? String ?? ""
                                    
                                    UserDefaults.standard.set(userID, forKey: "user_id")
                                    UserDefaults.standard.set(userfName, forKey: "first_Name")
                                    UserDefaults.standard.set(userLname, forKey: "last_Name")
                                    UserDefaults.standard.set(userphNo, forKey: "user_mobile")
                                    UserDefaults.standard.set(userMail, forKey: "user_email")
                                     UserDefaults.standard.set(userProfileImg, forKey: "user_photo")
                                    
                                    UserDefaults.standard.set(true, forKey: "user_login_status")
                                    let initialViewControlleripad  = storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                                    
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    
                                    let navigationController = UINavigationController(rootViewController: initialViewControlleripad)
                                    navigationController.navigationBar.prefersLargeTitles = true
                                    navigationController.navigationBar.isTranslucent = false
                                    DispatchQueue.main.async {
                                        appDelegate.window?.rootViewController = navigationController
                                        appDelegate.window?.makeKeyAndVisible()
                                    }
                                    
                
                                }
                                else
                                {
                                   alertShow(message: "Enter valid OTP")
                                }
            }}}
    
 
func alertShow(message:String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

