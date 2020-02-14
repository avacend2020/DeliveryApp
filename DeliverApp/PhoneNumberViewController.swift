//
//  PhoneNumberViewController.swift
//  DeliverApp
//
//  Created by User 2 on 4/25/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController , UITextFieldDelegate{
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var continueBtnAction: UIButton!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setUpNavigation()
        
        
    self.title = "Login"
    navigationController?.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    //   self.navigationController!.navigationBar.tintColor = UIColor.white;
       
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        phoneNumberField.addBottomBorder()
        passwordTxt.addBottomBorder()
        
        
        phoneNumberField.becomeFirstResponder()
        passwordTxt.becomeFirstResponder()
        
        
        
        
        continueBtnAction.layer.cornerRadius = continueBtnAction.frame.height / 2
        
        continueBtnAction.clipsToBounds = true 
        
 }
    
//func setUpNavigation(){
//
//        self.title = "Login "
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style:.done, target: self, action: #selector(backAction))
//
//}
//
//@objc func backAction(){
//
//    print("Back Button Clicked")
//
//    self.dismiss(animated: true, completion: nil)
//
// }
    
@IBAction func backBtnAction(_ sender: Any) {
    
    navigationController!.popViewController(animated: true)
    
 }
    
        
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
//
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
//        label.text = "+91"
//        label.textColor = UIColor.black
//        label.textAlignment = .left
//
//
//        leftView.addSubview(label)
//
//        phoneNumberField.leftView = leftView
//        phoneNumberField.leftViewMode = .always

        // Do any additional setup after loading the view.
  //  }
    

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//
//        if range.location == 9 || textField.text?.count == 10 {
//
//
//            if continueBtnAction.isHidden{
//
//                continueBtnAction.isHidden = false
//
//
//            }else{
//
//                continueBtnAction.isHidden = true
//            }
//
//        }else{
//
//          continueBtnAction.isHidden = true
//
//        }
//
//        return true
//    }

    @IBAction func continueBtnAction(_ sender: Any) {
        
        if phoneNumberField.text! == ""{
            alertShow(message: "Enetr Username")
            return
       }
        else if passwordTxt.text! == ""{
           alertShow(message: "Enter Password")
            return
        }
       
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/login")!, params: ["username" : phoneNumberField.text! , "password" : passwordTxt.text!], viewcontroller: self, finish:finishPost)
        
        print("success")
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        
        

//        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "verifyOtpViewController") as? verifyOtpViewController)!
//
//        self.present(vc, animated: true, completion: nil)
        
    }
    
func finishPost(message:String,data:Data?)->Void{
        
       if let jsonData = data {

        
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] {     // as? data type
                
                print("myJson is" , json)
                
                if String(describing: json["success"]!) == "true" {
                    print(" login success")
                    
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.startAnimating()
                    }
                  
                    let userfName = json["userfirstname"] as? String ?? ""
                    let userLname = json["userlastname"] as? String ?? ""
                    let userMail = json["useremail"] as? String ?? ""
                    let userphNo = json["usermobile"] as? String ?? ""
                    let userID = json["userid"] as? String ?? ""
                    let userProfileImg = json["userimage"] as? String ?? ""
                    
                    UserDefaults.standard.set(userID, forKey: "user_id")
                    UserDefaults.standard.set(userfName, forKey: "first_Name")
                    UserDefaults.standard.set(userLname, forKey: "last_Name")
                    UserDefaults.standard.set(userphNo, forKey: "user_mobile")
                    UserDefaults.standard.set(userMail, forKey: "user_email")
                    UserDefaults.standard.set(userProfileImg, forKey: "user_photo")
                    
                    UserDefaults.standard.set(true, forKey: "user_login_status")
                   
                   
                    DispatchQueue.main.async {
                         let HomeView = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                        self.present(HomeView, animated: true, completion: nil)
                    }
                    
                }else{
                    let alertmsg = json["err_msg"] as? String ?? ""
                    //show alert here
                    let alert = UIAlertController(title: "Alert", message:alertmsg , preferredStyle: UIAlertController.Style.alert)
//                    let clickAction = UIAlertAction(title: "Go to login", style: .default) { (clickAct) in
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    alert.addAction(clickAction)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                alertShow(message: "some thing went wrong")
                // show alert for something went wrong
            }
        }
    }
    
func alertShow(message:String){
        
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)

    }
    
    

}




