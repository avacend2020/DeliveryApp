//
//  OrderHistoryCell.swift
//  PIK N DROP
//
//  Created by Admin on 10/3/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import UIKit

class OrderHistoryCell: UITableViewCell {
    
    
    
    @IBOutlet weak var bgView: UIView!
    
   
   
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    @IBOutlet weak var orderID: UILabel!
    
    
    @IBOutlet weak var orderStatus: UILabel!
    
    
    
    @IBOutlet weak var deliveryDate: UILabel!
    
    @IBOutlet weak var priceAndType: UILabel!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        
 }
    
func loadData(){
    
    
//    bgView.layer.shadowColor = UIColor.brown.cgColor
//    bgView.layer.shadowOpacity = 0.3
//    bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
//    bgView.layer.shadowRadius = 5
//    bgView.layer.masksToBounds = false
//    bgView.layer.cornerRadius = 8
//    bgView.layer.masksToBounds = true
    
        
    }
    
 override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }




}
