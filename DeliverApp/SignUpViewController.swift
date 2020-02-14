//
//  SignUpViewController.swift
//  DeliverApp
//
//  Created by Admin on 7/1/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate {
    
    var updateUserId:String = ""
    var mobileno:String = ""
    
    
    
    var checkStatus = false
    
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!    //next
    
 
    @IBOutlet weak var nextButton1: UIButton!   //update
    @IBOutlet weak var roundButton: UIButton!
    
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    
    @IBOutlet weak var mobileNo: UITextField!
    
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var conformPassTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController!.navigationBar.tintColor = UIColor.white;
        
        
        
        firstNameTxt.addBottomBorder()
        lastNameTxt.addBottomBorder()
        mobileNo.addBottomBorder()
        emailId.addBottomBorder()
        passwordTxt.addBottomBorder()
        conformPassTxt.addBottomBorder()
        
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        mobileNo.delegate = self
        emailId.delegate = self
        passwordTxt.delegate = self
        conformPassTxt.delegate = self
        

       nextButton.layer.cornerRadius = nextButton.frame.height/2
       nextButton.clipsToBounds = true
        
       nextButton1.layer.cornerRadius = nextButton1.frame.height/2
       nextButton1.clipsToBounds = true
 
        privacyStatus()

    }
    
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.object(forKey: "user_id") != nil {
            updateUserId = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
            nextButton.isHidden = true
            nextButton1.isHidden = false
        }else{
            nextButton.isHidden = false
            nextButton1.isHidden = true
        }
    }
    
func isValidEmail(testStr:String) -> Bool {
    
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
        return emailTest.evaluate(with: testStr)
 }
    
func validate(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9]\\d{9}$"//"^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
 }
    @IBAction func checkBoxButtonAction(_ sender: Any) {
        
        if checkStatus == true {
            checkStatus = false
        }else{
            checkStatus = true
        }
        privacyStatus()
    }
    
    func privacyStatus() {
        
        if checkStatus == true {
            
            checkBoxButton.setImage(UIImage(named: "check-box.png"), for: .normal)
        }
        else
        {
            checkBoxButton.setImage(UIImage(named: "Uncheck-box.png"), for: .normal)
        }
    }
    
func formValidation() -> Bool {
        
        if firstNameTxt.text == "" {
            
            showAlert(msg: "Enter Firstname")
            return false
            
        }else if lastNameTxt.text == "" {
            showAlert(msg: "Enter Lastname")
            return false
            
        }else if mobileNo.text == "" {
            showAlert(msg: "Enter Mobile number")
            
        }else if self.validate(value: mobileNo.text!) == false {
            
            showAlert(msg: "Enter Valid Mobile number")
            return false
            
        }else if emailId.text == "" {
            
            showAlert(msg: "Enter Email")
            return false
            
        }else if self.isValidEmail(testStr: emailId.text!) == false {
            
            showAlert(msg: "Enter Valid Email")
            
             return false
        }else if passwordTxt.text == "" {
            
            showAlert(msg: "Enter Password")
            return false
            
        }else if conformPassTxt.text != passwordTxt.text{
            
            showAlert(msg: "your Entered Conform Password not matched")
            return false
            
        }else if checkStatus == false {
            
            showAlert(msg: "Check terms & conditions")
            return false
        }
        
        return true
            
        
    }
    
@IBAction func nextButtonAction(_ sender: Any) {
    
    guard formValidation() == true else {
        return
        
       }
            
            ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/registration")!, params: ["firstname" : firstNameTxt.text! , "lastname" : lastNameTxt.text!,"mobile" : mobileNo.text! , "email" :emailId.text! ,"password" :passwordTxt.text!], viewcontroller: self, finish:finishPost)
}
    
    @IBAction func nextButton1Action(_ sender: Any) {
       
        guard formValidation() == true else {
            return
            
        }//http://goflexi.in/ecommerce/delivery/APP/API/pdapi/registrationupdate?userid=115&firstname=ios&lastname=test&mobile=9998887776&email=iphone@gmail.com&password=ios
    
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/registrationupdate")!, params: ["userid":updateUserId, "firstname" : firstNameTxt.text! , "lastname" : lastNameTxt.text!,"mobile" : mobileNo.text! , "email" :emailId.text! ,"password" :passwordTxt.text!], viewcontroller: self, finish:finishPost1) 
        
        
            print("user updated")
    }
    
func finishPost1(message:String, data:Data?)->Void{
        
        if let jsonData = data
        {
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                let getMobileNo = json["usermobile"] as! String
                print("update mobile no",getMobileNo)
            
                
                
                
                if json["success"] as? String ?? "" == "true"{
                    let alertmsg = json["err_msg"] as? String ?? ""
                    //show alert here
                    let alert = UIAlertController(title: "Alert", message:alertmsg , preferredStyle: UIAlertController.Style.alert)
                    let clickAction = UIAlertAction(title: "Continue", style: .default) { (clickAct) in
                        
                        let otpVc = self.storyboard?.instantiateViewController(withIdentifier: "verifyOtpViewController") as! verifyOtpViewController
                        otpVc.userId = self.updateUserId
                        otpVc.mobileNo = getMobileNo
                        
                        
                        DispatchQueue.main.async {
                            self.present(otpVc, animated: true, completion: nil)
                        }
                        
                    }
                    alert.addAction(clickAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
         }
            
            }
        }
    
    
func showAlert(msg: String) {
        
        let alert = UIAlertController(title: "Alert", message:msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        navigationController!.popViewController(animated: true)
        
 }
    
    

    @IBAction func roundButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message:"Avacend Solutions Private Limited is a Private incorporated on 16 June 2003. It is classified as Non-govt company and is registered at Registrar of Companies, Chennai. Its authorized share capital is Rs. 10,000,000 and its paid up capital is Rs. 278,000. It is inolved in Manufacture of television and radio transmitters and apparatus for line telephony and line telegraphy Avacend Solutions Private Limited's Annual General Meeting (AGM) was last held on 29 September 2018 and as per records from Ministry of Corporate Affairs (MCA), its balance sheet was last filed on 31 March 2018.Directors of Avacend Solutions Private Limited are Govindarajulu Manivannan, Uma Anantaraman and Kalpana Anantaraman.Avacend Solutions Private Limited's Corporate Identification Number is (CIN) U32200TN2003PTC128092 and its registration number is 128092.Its Email address is khushwant.kumar@avacendsolutions.com and its registered address is Door No. 804, VIII Floor, Challa Mall No. 11, Sir Thyagaraya Road, T Nagar Chennai Chennai TN 600017 IN", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
func finishPost(message:String, data:Data?)->Void{

        if let jsonData = data
        {
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                
                let getuserid = json["userid"] as! String
                print("myUserId",getuserid)
                updateUserId = getuserid
                
                let getMobileNo = json["usermobile"] as! String
                print("myMobileno",getMobileNo)
            
                
                
                
                
                
                if String(describing: json["success"]!) == "true" {
                    print("new user registered")
                    UserDefaults.standard.set(updateUserId, forKey: "user_id")
                    
                    //mobile text pass
                    
                   
                    
                    
                    let otpVc = storyboard?.instantiateViewController(withIdentifier: "verifyOtpViewController") as! verifyOtpViewController
                    otpVc.userId = getuserid
                    otpVc.mobileNo = String(getMobileNo)
                    
                    
                    DispatchQueue.main.async {
                        self.present(otpVc, animated: true, completion: nil)
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
extension SignUpViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




