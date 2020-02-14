//
//  ProfileViewController.swift
//  DeliverApp
//
//  Created by Admin on 7/6/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var userId:String = "" 
    //Peoject send chey mail lo k nadi touch work kavatam ledu
    //mobile ki touch work kaladu
    
    
    
    let imagePickerController = UIImagePickerController()
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton! 
    
    @IBOutlet weak var firstNameEdittxt: UITextField!
    
    @IBOutlet weak var lastNameEditTxt: UITextField!
    
    @IBOutlet weak var mobileEditTxt: UITextField!
    
    @IBOutlet weak var emailEditTxt: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    
    //main view gredient color
//    let gradientLayerViewBase: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//    let gradientBase: CAGradientLayer = CAGradientLayer()
//    gradientBase.frame = gradientLayerViewBase.bounds
//    // gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//
//    gradientBase.colors = [UIColor(red: 35/255, green: 151/255, blue: 215/255, alpha: 1).cgColor, UIColor(red: 111/255, green: 94/255, blue: 211/255, alpha: 1).cgColor]
//
//    //  gradient.locations = [0.0, 0.35]
//    gradientBase.startPoint = CGPoint(x: 0.5, y: 0.0)
//    gradientBase.endPoint = CGPoint(x: 0.5, y: 1.0)
//    gradientLayerViewBase.layer.insertSublayer(gradientBase, at: 0)
//    self.view.layer.insertSublayer(gradientLayerViewBase.layer, at: 0)
//
    
    
    //setting scrollView gredient color using view give property as "scrollViewGredientView"
//    let gradientLayerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//    let gradient: CAGradientLayer = CAGradientLayer()
//    gradient.frame = gradientLayerView.bounds
//    // gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//
//    gradient.colors = [UIColor(red: 35/255, green: 151/255, blue: 215/255, alpha: 1).cgColor, UIColor(red: 111/255, green: 94/255, blue: 211/255, alpha: 1).cgColor]
//
//    //  gradient.locations = [0.0, 0.35]
//    gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
//    gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
//    gradientLayerView.layer.insertSublayer(gradient, at: 0)
//    self.scrollViewGredientView.layer.insertSublayer(gradientLayerView.layer, at: 0)
    
    
    
    
    
    
    
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    
    updateButton.layer.cornerRadius = updateButton.frame.height/2
    updateButton.clipsToBounds = true
    
    
    // TextField adding BorderColor
    
    firstNameEdittxt.addBottomBorder()
    lastNameEditTxt.addBottomBorder()
    mobileEditTxt.addBottomBorder()
    emailEditTxt.addBottomBorder()

    // profile round image
    
    profileImage.layer.cornerRadius = profileImage.frame.size.height/2
    profileImage.layer.borderWidth = 1.0
    profileImage.layer.masksToBounds = false 
    profileImage.clipsToBounds = true
    
  //  profileImage.layer.borderColor = UIColor.brown.cgColor
    

    //Edit Button Round Image
//
//    editButton.layer.cornerRadius = editButton.frame.size.height/2
//    editButton.layer.masksToBounds = true
//    editButton.layer.borderWidth = 1.0
//    editButton.clipsToBounds = true
    
   // editButton.layer.borderColor = UIColor.brown.cgColor
    
    
    //passing data login page  nsuserDefaluts to profile page
    userId = UserDefaults.standard.value(forKey: "user_id") as! String 
    firstNameEdittxt.text = UserDefaults.standard.value(forKey: "first_Name") as? String
    lastNameEditTxt.text = UserDefaults.standard.value(forKey: "last_Name") as? String
    mobileEditTxt.text = UserDefaults.standard.value(forKey: "user_mobile") as? String
    emailEditTxt.text = UserDefaults.standard.value(forKey: "user_email") as? String
    
    //checking the condition userphoto not equal to nil

    if UserDefaults.standard.value(forKey: "user_photo") != nil {
        let imgUrl = UserDefaults.standard.value(forKey: "user_photo") as? String ?? ""
        self.profileImage.sd_setImage(with: URL(string: imgUrl), completed: nil)
    }
    
    setupNavigation() 

}
    
func setupNavigation() {
        
        self.title = "Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .done, target: self, action: #selector(menuAction))
    
    
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
    self.navigationController!.navigationBar.tintColor = .white
    self.navigationController!.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]

    
}
    
@objc func menuAction() {
        
        let actionSheetController = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        //        let firstAction: UIAlertAction = UIAlertAction(title: "Share this app", style: .default) { action -> Void in
        //
        //            print("Share Action pressed")
        //        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "SignOut", style:.destructive) { action -> Void in
            UserDefaults.standard.set(false, forKey: "user_login_status")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let phoneviewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
            UIApplication.shared.keyWindow?.rootViewController = phoneviewController;
            
            print("SignOut Action pressed")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        // actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
        
 }
    
    @IBAction func editButtonAction(_ sender: Any) {
        
        
        let actionSheetController = UIAlertController(title:nil, message:"Add photo", preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Take photo", style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
                
                
            }
            else
            {
                print("Camera not Available")
            
            }
            
          
            print("Photo Action pressed")
    }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Choose from library", style:.default) { action -> Void in
            
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
            print("Library Action pressed")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style:.destructive) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
        
        
 }

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
    let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    
    profileImage.image = image
    
    picker.dismiss(animated: true, completion: nil)
    
}
func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
   
}
    
    
@IBAction func updateEditAction(_ sender: Any) {
        
   myImageUploadRequest()
   
}
 //image upload to the server
func myImageUploadRequest()
    {
       // let myUrl = NSURL(string: "http://www.swiftdeveloperblog.com/http-post-example-script/");
        let myUrl = NSURL(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/userupdate");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST"; 
        
        let param = [
            "userid"    : userId,
            "firstname"  : firstNameEdittxt.text!,
            "lastname"    :lastNameEditTxt.text!,
            "email":  emailEditTxt.text!,
            "mobile" : mobileEditTxt.text!] as! [String : Any]
        //"uploadimg":profileImage.image!
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image = self.profileImage.image!
        
        print("image name is ",image)

        let imgData = image.jpegData(compressionQuality: 0.7)
        
      //  UIImageJPEGRepresentation(myImageView.image!, 1)

//        let imageData = UIImage.jpegData(compressionQuality:0.7)

        
        if(imgData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "uploadimg", imageDataKey: imgData! as NSData, boundary: boundary) as Data
        
        
       // myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary ?? [:]
                
                print(json)
            
                
                let userfName = json["userfirstname"] as? String ?? ""
                let userLname = json["userlastname"] as? String ?? ""
                let userMail = json["useremail"] as? String ?? ""
                let userphNo = json["usermobile"] as? String ?? ""
                let userProfileImg = json["userimage"] as? String ?? ""
                
           
                UserDefaults.standard.set(userfName, forKey: "first_Name")
                UserDefaults.standard.set(userLname, forKey: "last_Name")
                UserDefaults.standard.set(userphNo, forKey: "user_mobile")
                UserDefaults.standard.set(userMail, forKey: "user_email")
                UserDefaults.standard.set(userProfileImg, forKey: "user_photo")

                
                DispatchQueue.main.async {
   
                    self.firstNameEdittxt.text = userfName
                    self.lastNameEditTxt.text = userLname
                    self.mobileEditTxt.text = userphNo
                    self.emailEditTxt.text = userMail
                    self.profileImage.sd_setImage(with: URL(string: userProfileImg), completed: nil)
                }
                   
                
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}

