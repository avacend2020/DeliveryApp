//
//  PaymentTypeCell.swift
//  PIK N DROP
//
//  Created by Admin on 1/14/20.
//  Copyright © 2020 User 2. All rights reserved.
//

import UIKit

class PaymentTypeCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var paymentTypeName: UILabel!
    
    @IBOutlet weak var payNowBtnProperty: UIButton!
    
    
    @IBOutlet weak var radioImage: UIImageView!
    
    
    @IBOutlet weak var heightForCell: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
 }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
