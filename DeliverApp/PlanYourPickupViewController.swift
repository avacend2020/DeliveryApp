//
//  PlanYourPickupViewController.swift
//  DeliverApp
//
//  Created by Admin on 7/11/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class PlanYourPickupViewController: UIViewController {
    
    
    @IBOutlet weak var pickUpTodayBackgroundView: UIView!
    
    var userId:String = ""
    var getDateUserSelect:String = ""
    var getUserTimeSelect:String = ""
    var gettingCurrentDateAndTimeService:String = ""
    
    let datePicker = UIDatePicker()
    var cDate = Date()
    
    
    var address_id: String = ""    //2 from manual
    
    var locationObj: Address?      //1 from tableview 
    
    var fromID: Int = 0
    
    var actualAddressID = String()
    
  
    @IBOutlet weak var pickupTodayBackgroundView: UIView!
    
    
    @IBOutlet weak var scheduleApickupBackgroundView: UIView!
    
    
    @IBOutlet weak var pickupTodayBtnProperty: UIButton!
    
    @IBOutlet weak var ScheduleApickupBtnProperty: UIButton!
    

    @IBOutlet weak var startingTimeProperty: UIButton!
    
    @IBOutlet weak var endingTimeProperty: UIButton!
    
    @IBOutlet weak var pickupImageView: UIImageView!
    
    @IBOutlet weak var ScheduleAPickupImageView: UIImageView!
    
    
    @IBOutlet weak var datePickCalender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickUpTodayBackgroundView.layer.cornerRadius = 10
        
        // border
        pickUpTodayBackgroundView.layer.borderWidth = 1.0
        pickUpTodayBackgroundView.layer.borderColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1).cgColor
        
        // shadow
        pickUpTodayBackgroundView.layer.shadowColor = UIColor.black.cgColor
        pickUpTodayBackgroundView.layer.shadowOffset = CGSize(width: 3, height: 3)
        pickUpTodayBackgroundView.layer.shadowOpacity = 0.7
        pickUpTodayBackgroundView.layer.shadowRadius = 4.0
        
        
        
        scheduleApickupBackgroundView.layer.cornerRadius = 10
        
        // border
        scheduleApickupBackgroundView.layer.borderWidth = 1.0
        scheduleApickupBackgroundView.layer.borderColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1).cgColor
        
        // shadow
        scheduleApickupBackgroundView.layer.shadowColor = UIColor.black.cgColor
        scheduleApickupBackgroundView.layer.shadowOffset = CGSize(width: 3, height: 3)
        scheduleApickupBackgroundView.layer.shadowOpacity = 0.7
        scheduleApickupBackgroundView.layer.shadowRadius = 4.0
        
        
        //1: - from table cell taps, 2: from manual
        
        
        if fromID == 1 {
            
            actualAddressID = locationObj?.addressID ?? ""
            
            print("table  actualAddressID is",actualAddressID)
            
        }else{
            actualAddressID = address_id
            
            print("manual entry  actualAddressID is",actualAddressID)
        }
        
        
      if  pickupTodayBtnProperty.isEnabled == true{

        let date = self.getDate(date: datePicker.date)
        print(date)
        self.datePickCalender.setTitle(date, for: .normal)
        
 //      I will commited for schedule A pickup also selected at any time before its uncommited
        
//        self.datePickCalender.isSelected = false
//        self.datePickCalender.isUserInteractionEnabled = false
        
    }
      else{
        
            self.datePickCalender.setTitle("Date Calender", for: .normal)
            self.datePickCalender.isUserInteractionEnabled = true
        
     }
        
       //compareDates()
      //passing userId phonenoViewControler to here
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String // pass this date as parameter in continue btn
        print("myUserId",userId)
        
        
        
        ApiService.callGet(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/currdate")!, params:[:], viewcontroller: self, finish:finishPost)
        
        
        startingTimeProperty.layer.cornerRadius = 5.0
        startingTimeProperty.layer.masksToBounds = true
        startingTimeProperty.layer.borderColor = UIColor.orange.cgColor
        
        endingTimeProperty.layer.cornerRadius = 5.0
        endingTimeProperty.layer.masksToBounds = true
        endingTimeProperty.layer.borderColor = UIColor.orange.cgColor
        
 }
    override func viewWillAppear(_ animated: Bool) {

        //intially show the defalut border color starting time button
        startingTimeProperty.layer.borderColor = UIColor(red: 91/255.0, green: 199.0/255.0, blue: 240/255.0, alpha: 1).cgColor
        startingTimeProperty.layer.borderWidth = 1
        


        //intially show the defalut border color Ending time button

        endingTimeProperty.layer.borderColor = UIColor(red: 91/255.0, green: 199/255.0, blue: 240/255.0, alpha: 1).cgColor
        endingTimeProperty.layer.borderWidth = 1
      
    }
    
    
func finishPost(message:String,data:Data?)->Void{
        
        if let jsonData = data {
            
            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] {  // as? data type
                
                print(json)
                
                let getCurrentDateAndTime = json["cdate"] as! String
                
                print(getCurrentDateAndTime)
                
                gettingCurrentDateAndTimeService = getCurrentDateAndTime
                print("getting current date and time from service ",gettingCurrentDateAndTimeService)
                
                compareDates()
//                if gettingCurrentDateAndTimeService == compareDates() as? String {
//
//                   print("Pickup today")
//
//
//                }
//                else{
//
//                    print("Schedule A Pickup")
//
//                    }

            }
        }
    }
    
   
func compareDates() {
    
     // let currentSDate = cDate//getDateFromTime(time: "11:45") // system time
       let currentSDate = getServerTime(dStr: gettingCurrentDateAndTimeService)// server time
    
        let firstDate = getDateFromTime(time: "9:30")
        let secondDate = getDateFromTime(time: "11:30")
        let thirdDate = getDateFromTime(time: "12:00")
        let fourthDate = getDateFromTime(time: "13:00")
 

        if currentSDate <= firstDate {
            print("Time is before delivery time")
            DispatchQueue.main.async {
                self.startingTimeProperty.isEnabled = true
                self.endingTimeProperty.isEnabled = true
        }
            
            //1
        }else if currentSDate >= firstDate && currentSDate <= secondDate {
            //2//firstTime
            print("Between first half")
            DispatchQueue.main.async {
                self.startingTimeProperty.isEnabled = true
                self.endingTimeProperty.isEnabled = true
            }
            
        }else if currentSDate >= secondDate &&  currentSDate <= thirdDate {
            // middle time  3
          print("Between break")
            DispatchQueue.main.async {
                self.startingTimeProperty.isEnabled = false
                self.endingTimeProperty.isEnabled = true
            }
           
        }
        else if currentSDate >= thirdDate && currentSDate <= fourthDate {
       print("Between second half")  //4
            DispatchQueue.main.async {
                self.startingTimeProperty.isEnabled = false
                self.endingTimeProperty.isEnabled = true
            }
            
            

        }else if currentSDate >= fourthDate {
            //5 no timming available
            print("After delivery time")
           DispatchQueue.main.async {
                self.startingTimeProperty.isEnabled = false
                self.endingTimeProperty.isEnabled = false
                self.pickUpTodayBackgroundView.alpha = 0.4
                self.pickupTodayBtnProperty.isEnabled = false
                
                
                self.datePickCalender.setTitle("Date Calender", for: .normal)
                self.datePickCalender.isUserInteractionEnabled = true
            
            }
            
        }else{

           print("your delivery time completed")

            DispatchQueue.main.async {
                self.pickupTodayBtnProperty.isEnabled = false
                self.pickupTodayBtnProperty.setImage(UIImage(named: "unselected_Radio.png"), for: .normal)
                self.ScheduleApickupBtnProperty.setImage(UIImage(named: "Selected_Radio.png"), for: .normal)

        }

    }
    
}

func getDateFromTime(time: String) -> Date {

  let timeData = time.replacingOccurrences(of: "AM", with: "").replacingOccurrences(of: "PM", with: "").replacingOccurrences(of: " ", with: "")
    
    let timeComponents = timeData.components(separatedBy: ":")
    
    guard timeComponents.count > 0 else {
        return Date()
    }
    
    let hur = Int(timeComponents[0])!
    let min = Int(timeComponents[1])!
    let requireddate = cDate.dateAt(hours: hur, minutes: min)
    return requireddate
  
    }
    
    func getServerTime(dStr: String) -> Date {
        let formate = DateFormatter()
        formate.dateFormat = "dd-MM-yyyy hh:mm:ss a"
        let dt = formate.date(from: dStr)
        return dt!
    }
    
func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
   pickUpTodayBackgroundView.layer.masksToBounds = false
   pickUpTodayBackgroundView.layer.shadowColor = color.cgColor
   pickUpTodayBackgroundView.layer.shadowOpacity = opacity
   pickUpTodayBackgroundView.layer.shadowOffset = offSet
   pickUpTodayBackgroundView.layer.shadowRadius = radius
        
 //  pickupTodayBtnProperty.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
   pickUpTodayBackgroundView.layer.shouldRasterize = true
   pickUpTodayBackgroundView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    
    
}
    
 func dropColorShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    
        scheduleApickupBackgroundView.layer.masksToBounds = false
        scheduleApickupBackgroundView.layer.shadowColor = color.cgColor
        scheduleApickupBackgroundView.layer.shadowOpacity = opacity
        scheduleApickupBackgroundView.layer.shadowOffset = offSet
        scheduleApickupBackgroundView.layer.shadowRadius = radius
        
        //  pickupTodayBtnProperty.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        scheduleApickupBackgroundView.layer.shouldRasterize = true
        scheduleApickupBackgroundView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
  



    @IBAction func pickupTodayButtonAction(_ sender: Any) { 
        
        
        pickupTodayBtnProperty.setImage(UIImage(named: "Selected_Radio.png"), for: .normal)
        ScheduleApickupBtnProperty.setImage(UIImage(named: "unselected_Radio.png"), for: .normal)
        
        
        
//        pickupTodayBtnProperty .dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
    }
    
    @IBAction func scheduleApickupBtnAction(_ sender: Any) {
        
        pickupTodayBtnProperty.setImage(UIImage(named: "unselected_Radio.png"), for: .normal)
        ScheduleApickupBtnProperty.setImage(UIImage(named: "Selected_Radio.png"), for: .normal)
        
    }

    @IBAction func ScheduleAPickupDateButton(_ sender: Any) {
        
        
       //let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(60*60*24*30)
        datePicker.datePickerMode = .date
        
        let dateAlert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: 250, height: 200)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (okAction) in
    
            let date = self.getDate(date: self.datePicker.date)
            print(date)
        self.datePickCalender.setTitle(date, for: .normal)
          // getting date here declare globally asign value
            
            self.getDateUserSelect = date // pass this date as parameter in continue btn
            self.cDate = (self.datePicker.date).dateAt(hours: 00, minutes: 00)
            self.compareDates()
            
         print("getUserSelect",self.getDateUserSelect)
            
   }
        
        let camcelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        
        dateAlert.view.addSubview(datePicker)
        
        dateAlert.addAction(camcelAction)
        dateAlert.addAction(okAction)
        
        self.present(dateAlert, animated: true, completion: nil)
     
    }
    
func getDate(date: Date) -> String {
        
        guard date != nil else {
            return ""
        }
    
// let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:.short, timeStyle:.short)


       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MMM-yyyy"
    
        
    let dateStr = formatter.string(from: date)
    
        return dateStr
    }
    
    
    @IBAction func planPickUpBtn(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    
    @IBAction func startingTimeButton(_ sender: Any) {
        
//        endingTimeProperty.layer.borderColor = UIColor.clear.cgColor

        
        startingTimeProperty.backgroundColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
       startingTimeProperty.setTitleColor(UIColor.white, for:UIControl.State.normal)
       endingTimeProperty.setTitleColor(UIColor.black, for: UIControl.State.normal)

        endingTimeProperty.backgroundColor = .clear // above two commit lines before used
       
        let startingTime = startingTimeProperty.currentTitle!
       
        getUserTimeSelect = startingTime
        
        print("getuserTime",getUserTimeSelect)
  }
    
    @IBAction func endingTimeAction(_ sender: Any) {
     //  startingTimeProperty.layer.borderColor = UIColor.clear.cgColor

        endingTimeProperty.backgroundColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)

        endingTimeProperty.setTitleColor(UIColor.white, for: UIControl.State.normal)
        startingTimeProperty.setTitleColor(UIColor.black, for: UIControl.State.normal)

        startingTimeProperty.backgroundColor = .clear  // above two commit lines before used

       
        let endingTime = endingTimeProperty.currentTitle!
        getUserTimeSelect = endingTime
        
        print("getuserTime",getUserTimeSelect)
        
}
    
func AlertMessage(msg:String){
        
        
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
//func formValidation()-> Bool{
//
//
//    if pickupTodayBtnProperty.isSelected == false || ScheduleApickupBtnProperty.isSelected == false ||  startingTimeProperty.isSelected == false || endingTimeProperty.isSelected == false   {
//
//        print("not selected ")
//
//      //  AlertMessage(msg: "Select Pickup Today or Schedule A pickup")
//        return false
//
//    } else {
//
//         print("not selected")
//      //  AlertMessage(msg: "Select Starting Time or Ending Time ")
//        return false
//
//    }
//
//        return true
//
//}
    
    
    
    
    
    @IBAction func continueButtonAction(_ sender: Any) {
        
//        guard formValidation() == true else {
//            return
//        }
        
        
        ApiService.callPost(url: URL.init(string: "http://goflexi.in/ecommerce/delivery/APP/API/pdapi/schedule")!, params: ["userid" : userId,"sdate":getDateUserSelect,"stime":getUserTimeSelect,"address_id": self.actualAddressID], viewcontroller: self, finish:finishPost1)
 }
    
func finishPost1(message:String,data:Data?)->Void{
        
        if let jsonData = data {
            
            if let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : AnyObject] { // as? data type
                
                print(json)
                
            
                let getPickUpIDPassMainDeliveryVC = json["pickup_id"] as! String
                print("pickUp id is",getPickUpIDPassMainDeliveryVC)
                
                
                
                if json["success"] as? String ?? "" == "true" {
                  //  let err_msg = json["err_msg"] as? String
                    
//                    let alert = UIAlertController(title: "", message: "Saved Date And Time This Address", preferredStyle: .alert)
//
                   // alert.view.tintColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
                    
                    
                    
                    
//                let okAction = UIAlertAction(title: "Continue", style: .default) { (clickAct) in
//                    
                    
                        let deliveryAddressViewController  = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryMainAddressViewController") as! DeliveryMainAddressViewController
                        deliveryAddressViewController.getDeliverySelectedDate = self.getDateUserSelect // pass date to Delivry Main View
                        deliveryAddressViewController.currentDate = self.gettingCurrentDateAndTimeService
                        
                        deliveryAddressViewController.getDeliverySelectedTime = self.getUserTimeSelect  //pass time to Delivery main View
                        deliveryAddressViewController.pickUpID = getPickUpIDPassMainDeliveryVC 
                        
                        
                        DispatchQueue.main.async {

           let navBar = UINavigationController(rootViewController: deliveryAddressViewController)
    self.present(navBar, animated: true, completion: nil)
                            
                        }
                        
                    }
//                    alert.addAction(okAction)
//                    DispatchQueue.main.async {
//
//                        self.present(alert, animated: true, completion: nil)
//                    }
  }
}
 }
}
//}

extension Date{
    
func dateAt(hours: Int, minutes: Int) -> Date {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        var date_components = calendar.components(
            
            [NSCalendar.Unit.year,
             
             NSCalendar.Unit.month,
             
             NSCalendar.Unit.day],from: self)
        
        
        
        //Create an NSDate for the specified time today.
        
        date_components.hour = hours
        
        date_components.minute = minutes
        
        date_components.second = 0
        
        
        
        let newDate = calendar.date(from: date_components)!
        
        return newDate
        
 }

    }


