//
//  HttpRequest.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/22.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation
import UIKit

class HttpRequest {
    
    var appDel :AppDelegate
    
    
    init()
    {
        appDel = (UIApplication.sharedApplication().delegate as? AppDelegate)!
        
    }
    
    internal func makePostRequest(url : NSURL ,body : AnyObject)
    {

        do {
           // let json : [String: AnyObject] = [ "username"  : txtUsername.text!, "password" : txtPassword.text!]
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            
            // create post request
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue((appDel.services?.getToken())!, forHTTPHeaderField: "Authorization")
            
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                        
                        do {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                            
                            var pt : MyProtocol
                            pt = MyProtocol.init()
                            pt.requestFinished(httpResponse.statusCode, dic: jsonResult)
                            print("Result -> \(jsonResult.valueForKey("username"))")
                            
                        } catch {
                            
                            var pt : MyProtocol
                            pt = MyProtocol.init()
                            pt.requestFinished(httpResponse.statusCode, dic: "")
                            print("Error and here")
                        }
                        
                    
                }else
                {
                    
                }
                
                if error != nil{
                    
                    print("NetWorkConnection")
                    return
                }
                
            }
            
            task.resume()
            
            while task.state == NSURLSessionTaskState.Running {
                
            }
            print("task done")
        } catch {
            print(error)
        }
        

    }
}