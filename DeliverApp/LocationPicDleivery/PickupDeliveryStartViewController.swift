//
//  PickupDeliveryStartViewController.swift
//  PIK N DROP
//
//  Created by Admin on 12/19/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
class PickupDeliveryStartViewController: UIViewController {
    
    @IBOutlet weak var confirmOrderButtonProperty: UIButton!
    @IBOutlet weak var underLine1: UILabel!
    @IBOutlet weak var underlime2: UILabel!
    @IBOutlet weak var underline3: UILabel!
    @IBOutlet weak var docBtn: UIButton!
    @IBOutlet weak var deliveryLocabtn: UIButton!
    @IBOutlet weak var pickUpBtn: UIButton!
    @IBOutlet weak var searchPickupUnderline: UILabel!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var imgCheck1: UIImageView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var imgCheck2: UIImageView!
    @IBOutlet weak var lineView3: UIView!
    @IBOutlet weak var imgCheck3: UIImageView!
    
    @IBOutlet weak var deliveryPartnerBreakDownView: UIView!
    
    @IBOutlet weak var payNowBtnProperty: UIButton!
    
    @IBOutlet weak var partnerDeliveryLabel: UILabel!
    
    @IBOutlet weak var totalCost: UILabel!
    
    @IBOutlet weak var totalCostConformOrder: UILabel!
    
    @IBOutlet weak var paymentDetailsView: UIView!
    
    @IBOutlet weak var confirmOrderView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    // @IBOutlet weak var searchDeliveryUnderlineLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    @IBOutlet weak var anyInstructionsTextfield: UITextField!
    
  // @IBOutlet weak var foodDocumentsUnderlineLabel: UILabel!
    
    var brightness: CGFloat = 0.0
    var totalPaidItem:String = ""
    
    var priceSelectedTxtGettingDocumentViewControllerTopartnerView:String = ""
    
    var WeightSelectedTxtGettingDocumentViewControllerTopartnerView:String = ""
    

override func viewDidLoad() {
        super.viewDidLoad()
    
    paymentDetailsView.isHidden = true
    confirmOrderView.isHidden = true
    
    deliveryPartnerBreakDownView.isHidden = true
    
    deliveryPartnerBreakDownView.cornerRadius = 10.0
    
    
    anyInstructionsTextfield.placeholder = " Any instructions? Eg: Don't ring the doorbell "
    anyInstructionsTextfield.textColor = .black
    
    
    
    self.totalPaidItem = totalCostConformOrder.text!
    
    self.totalCost.text = "₹" + String(format:"%..2f", totalCost)
    
    self.totalCostConformOrder.text = "₹" + String(format:"%..2f", totalCostConformOrder)
    
    
    self.navigationController?.navigationBar.isHidden = true
    confirmOrderButtonProperty.layer.cornerRadius = confirmOrderButtonProperty.frame.height/2
    confirmOrderButtonProperty.clipsToBounds =  true
    
    
    
    payNowBtnProperty.layer.cornerRadius = payNowBtnProperty.frame.height/2
       payNowBtnProperty.clipsToBounds =  true
    

 }


    @IBAction func partnerDeliveryFeeBtnPresent(_ sender: Any) {
        
        self.deliveryPartnerBreakDownView.isHidden = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PickupDeliveryStartViewController.dismissView))
        view.addGestureRecognizer(tap)
        

        self.distanceLabel.text = AppConstants.TotalDistance
        self.priceLabel.text =  priceSelectedTxtGettingDocumentViewControllerTopartnerView
        self.weightLabel.text = String(format: "%@GMS", WeightSelectedTxtGettingDocumentViewControllerTopartnerView)
        self.totalPriceLabel.text = priceSelectedTxtGettingDocumentViewControllerTopartnerView
                   
 }
@objc func dismissView() {
    
        self.deliveryPartnerBreakDownView.isHidden = true
      
    }
   
        
    @IBAction func deliveryPartnerDissmissBtn(_ sender: Any) {
        
        
        self.deliveryPartnerBreakDownView.isHidden = true
        
    }
    
 
    
    
    
    
override func viewWillAppear(_ animated: Bool) {
        
        if AppConstants.pickupLocation?.address == "" || AppConstants.pickupLocation?.address == nil{
            
            pickUpBtn.setTitle("Search Pickup location", for: UIControl.State.normal)

           imgCheck1.image =  #imageLiteral(resourceName: "Unselected_Radio")
             lineView1.backgroundColor = .clear
            lineView1.makeDashedBorderLine()
            
        }else{
            for layer in lineView1.layer.sublayers ?? []{
                layer.removeFromSuperlayer()
            }
            imgCheck1.image =  #imageLiteral(resourceName: "tick")
            lineView1.backgroundColor = .gray
            pickUpBtn.setTitle(AppConstants.pickupLocation?.address, for: UIControl.State.normal)
        }
        if AppConstants.deliveryLocation?.address == "" || AppConstants.deliveryLocation?.address == nil{
              imgCheck2.image =  #imageLiteral(resourceName: "Unselected_Radio")
              lineView2.backgroundColor = .clear
              lineView2.makeDashedBorderLine()
              deliveryLocabtn.setTitle("Search Delivery location", for: UIControl.State.normal)
            }else{
               for layer in lineView2.layer.sublayers ?? []{
                    layer.removeFromSuperlayer()
                }
                imgCheck2.image =  #imageLiteral(resourceName: "tick")
                lineView2.backgroundColor = .gray
                deliveryLocabtn.setTitle(AppConstants.deliveryLocation?.address, for: UIControl.State.normal)
            
        }
       setupDocumentView()
         if AppConstants.pickupLocation?.address == "" || AppConstants.pickupLocation?.address == nil{
            
             underLine1.backgroundColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
             underlime2.backgroundColor = .gray
             underline3.backgroundColor = .gray
         }else if AppConstants.deliveryLocation?.address == "" || AppConstants.deliveryLocation?.address == nil{
             underlime2.backgroundColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
            underLine1.backgroundColor = .gray
            underline3.backgroundColor = .gray
         }else if AppConstants.Documents == nil{
             underline3.backgroundColor = UIColor(red: 91/255, green: 199/255, blue: 240/255, alpha: 1)
             underlime2.backgroundColor = .gray
             underLine1.backgroundColor = .gray
         }else{
            underline3.backgroundColor = .gray
            underlime2.backgroundColor = .gray
            underLine1.backgroundColor = .gray
        }
        
        
        
//        if AppConstants.pickupLocation?.address == "" || AppConstants.pickupLocation?.address == nil{
//            deliveryLocabtn.isUserInteractionEnabled = false
//            docBtn.isUserInteractionEnabled = false
//            pickUpBtn.isUserInteractionEnabled = true
//        }else if AppConstants.deliveryLocation?.address == "" || AppConstants.deliveryLocation?.address == nil{
//                  deliveryLocabtn.isUserInteractionEnabled = true
//                  docBtn.isUserInteractionEnabled = false
//                  pickUpBtn.isUserInteractionEnabled = true
//        }else{
//            deliveryLocabtn.isUserInteractionEnabled = true
//            docBtn.isUserInteractionEnabled = true
//            pickUpBtn.isUserInteractionEnabled = true
//        }
    }
    
func setupDocumentView(){
        
//        deliveryLocabtn.isUserInteractionEnabled = true
//        docBtn.isUserInteractionEnabled = true
//        pickUpBtn.isUserInteractionEnabled = true
        
        if AppConstants.Documents == nil{
                docBtn.setTitle("Select Documents", for: UIControl.State.normal)
                  imgCheck3.image =  #imageLiteral(resourceName: "Unselected_Radio")
                lineView3.backgroundColor = .clear
                lineView3.makeDashedBorderLine()
            }else{
                 for layer in lineView3.layer.sublayers ?? []{
                    layer.removeFromSuperlayer()
                 }
                 imgCheck3.image =  #imageLiteral(resourceName: "tick")
                 lineView3.backgroundColor = .gray
                 docBtn.setTitle(AppConstants.Documents?.CatName ?? "", for: UIControl.State.normal)
            }
    }
    @IBAction func searchPickuploactionButton(_ sender: Any) {
        
        let bookNowView = storyboard?.instantiateViewController(withIdentifier: "BookNowViewController") as! BookNowViewController
        bookNowView.isPickup = true
        self.navigationController?.pushViewController(bookNowView, animated: true)
        
    }

    
    @IBAction func searchDeliverylocationButton(_ sender: Any) {
        let bookNowView = storyboard?.instantiateViewController(withIdentifier: "BookNowViewController") as! BookNowViewController
            bookNowView.isPickup = false
        self.navigationController?.pushViewController(bookNowView, animated: true)
    }
    
    @IBAction func selectCategory(_ sender: UIButton) {
        
        let docVC = storyboard?.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC
        docVC.modalPresentationStyle = .overCurrentContext
        
        
        
        docVC.setupuAction{ (price,weight) in
            
            self.paymentDetailsView.isHidden = false
            self.confirmOrderView.isHidden = false
            
            
            self.partnerDeliveryLabel.text =  price
            self.totalCost.text =  price
            self.totalCostConformOrder.text =  price
            
            //getting selected price,weight Docment vc here
            self.priceSelectedTxtGettingDocumentViewControllerTopartnerView = price
            self.WeightSelectedTxtGettingDocumentViewControllerTopartnerView = weight
            
            
            self.dismiss(animated: true, completion: nil)
            self.setupDocumentView()
            
        }
        self.present(docVC, animated: true, completion: nil)
        
    }
    
    @IBAction func termsAndConditionsButtonAction(_ sender: Any) {
     
        let termsAndConditions = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        
        let navigation = UINavigationController(rootViewController: termsAndConditions)
        
        DispatchQueue.main.async {
            self.navigationController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func helpLineBtn(_ sender: Any) {
        
        let helpButton = storyboard?.instantiateViewController(withIdentifier: "HelpLineButtonViewController") as! HelpLineButtonViewController
                  
      self.navigationController?.pushViewController(helpButton, animated: true)
        
        
    }
    
    
    @IBAction func payNowBtnAction(_ sender: Any) {
        
         let paymentType = storyboard?.instantiateViewController(withIdentifier: "DeliveryPaymentViewController") as! DeliveryPaymentTypeViewController
        
        self.totalPaidItem = totalCostConformOrder.text!
         print(totalPaidItem)
        paymentType.itemTotalAmount = String(totalPaidItem)
        paymentType.totalItemAmount = String(totalPaidItem)
      // print(totalItemAmount)
        self.navigationController?.pushViewController(paymentType, animated: true)
        
    }
    
 
    
    @IBAction func confirmOrderButtonAction(_ sender: Any) {
        
        
    }
    
}


extension UIView {
    private static let lineDashPattern: [NSNumber] = [2, 2]
    private static let lineDashWidth: CGFloat = 1.0

    func makeDashedBorderLine() {
            let lineLayer = CAShapeLayer()
              lineLayer.strokeColor = UIColor.gray.cgColor
              lineLayer.lineWidth = 2
              lineLayer.lineDashPattern = [4,4]
              let path = CGMutablePath()
              path.addLines(between: [CGPoint(x: 0, y: 0),
                                      CGPoint(x: 0, y: self.frame.height)])
              lineLayer.path = path
              self.layer.addSublayer(lineLayer)
    }
}
extension UIImageView{
    func setImagetintColour(colour:UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = colour
    }
}
