//
//  LocalConstants.swift
//  PIK N DROP
//
//  Created by Venkatesh S on 22/12/2019.
//  Copyright © 2019 User 2. All rights reserved.
//

import Foundation
import CoreLocation
enum AppConstants {
    static var pickupLocation : LocationModel?
    static var deliveryLocation : LocationModel?
    static var Documents : SelectedDoc?
    static var TotalDistance = "0"
    static var notifications = [String]()
}
struct LocationModel{
    
    var latitude : CLLocationCoordinate2D?
    var address : String = ""
    var flatno:String = ""
    var appartmentName:String = ""
    
    init(latitude : CLLocationCoordinate2D,address : String,flatno : String,appartmentName:String) {
        
        self.latitude = latitude
        self.address = address
        
        self.flatno = flatno
        self.appartmentName = appartmentName
        
    }
}
struct SelectedDoc{
    var id: String?
    var weight: String?
    var price : String?
    var CatName :String?
    init(ID: String, weight: String ,price : String , CatName :String?) {
        id = ID
        self.weight = weight
        self.price = price
        self.CatName = CatName
    }
}

//struct selectedDistance {
//
//    var distanceKM:String?
//
//}
