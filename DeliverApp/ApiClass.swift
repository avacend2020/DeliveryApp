//
//  ApiClass.swift
//  DeliverApp
//
//  Created by User 2 on 5/8/19.
//  Copyright © 2019 User 2. All rights reserved.
//

import Foundation
import UIKit

class ApiService
{
    
static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        
        return data.map { String($0) }.joined(separator: "&")
        
  }
    
static func callPost(url:URL, params:[String:Any],viewcontroller:UIViewController , finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = self.getPostString(params: params)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        request.allHTTPHeaderFields = ["Content-Type" : "application/x-www-form-urlencoded"]
        var result:(message:String, data:Data?) = (message: "Network Error", data: nil)

        if Reachability.isConnectedToNetwork() == true{
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if(error != nil)
                {
                    
                    result.message = "Fail Error not null : \(error.debugDescription)"
                    
                }
                else
                {
                    
                    result.message = "Success"
                    result.data = data
                 
                }
                finish(result)
            }
            task.resume()
        }else{
            
            finish(result)
        }
        
        
    }
    
static func callGet(url:URL, params:[String:Any],viewcontroller:UIViewController ,finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let postString = self.getPostString(params: params)
        
        request.httpBody = postString.data(using: .utf8)
        
        var result:(message:String, data:Data?) = (message: "Network Error", data: nil)
        
        if Reachability.isConnectedToNetwork() == true{
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if(error != nil)
                {
                    result.message = "Fail Error not null : \(error.debugDescription)"
                }
                else
                {
                    result.message = "Success"
                    result.data = data
                    
                     print(response!)
                }
                
                finish(result)
            }
            
            task.resume()
            
        }else{
            
            finish(result)
            
        }
        
    }
}
