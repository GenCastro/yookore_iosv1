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
    
    /*internal func makeRequest(url : NSURL ,body : AnyObject,objClass : String,funcName :String)
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
            
            
            defer{
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    
                    if code == 200 || code == 201
                    {
                        do
                        {
                            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                            
                        }catch
                        {
                            print("couldnot convert to json")
                        }
                    }else
                    {
                        
                    }
                    
                   
                    
                }else
                {
                    
                }
                
                if error != nil{
                    
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR", message:"No Network Connection", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                    return
                }
                
            }
            
            task.resume()
            
            print("task done")}
        } catch {
            print(error)
        }
        

    }*/
    
    internal func getRequest(url : NSURL ,body : AnyObject,method:String) ->  NSMutableURLRequest
    {
        
      
    
        do{
            
            // create post request
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = method
            
            if method != "GET"
            {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
                print(jsonData)
                request.HTTPBody = jsonData
            }
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue((appDel.services?.getToken())!, forHTTPHeaderField: "Authorization")
            
            return request
        }catch
        {
            return NSMutableURLRequest()
        }

        
        
    }
    
    
    
    
}