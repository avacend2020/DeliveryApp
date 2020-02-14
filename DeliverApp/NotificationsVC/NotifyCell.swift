//
//  NotifyCell.swift
//  PIK N DROP
//
//  Created by Venkatesh S on 12/02/2020.
//  Copyright © 2020 User 2. All rights reserved.
//

import UIKit

class NotifyCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
   
    }

override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }
    
}
