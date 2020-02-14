//
//  NotificationVC.swift
//  PIK N DROP
//
//  Created by Venkatesh S on 12/02/2020.
//  Copyright © 2020 User 2. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.separatorStyle = .none 
        tblList.register(UINib(nibName: "NotifyCell", bundle: nil), forCellReuseIdentifier: "NotifyCell")
    }
    
override func viewWillAppear(_ animated: Bool) {
    
        tblList.isHidden = (AppConstants.notifications.count == 0)
        tblList.reloadData()
    }
}

extension NotificationVC:UITableViewDataSource,UITableViewDelegate{
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AppConstants.notifications.count
    
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
 let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyCell", for: indexPath) as! NotifyCell
    
    cell.lblText.text = AppConstants.notifications[indexPath.row]
    
     return cell
    
    }
    
}

