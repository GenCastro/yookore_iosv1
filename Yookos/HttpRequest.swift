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
    
    internal func makePostRequest(url : NSURL ,body : AnyObject,objClass : String,funcName :String)
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
                    var pt : MyProtocol
                    pt = MyProtocol.init()
                    pt.postRequestFinished(httpResponse.statusCode, dic: data!,objClass: objClass,funcName: funcName)
                    print(" passed 1" )
                    
                }else
                {
                    
                }
                
                if error != nil{
                    
                    print(error)
                    return
                }
                
            }
            
            task.resume()
            
            print("task done")}
        } catch {
            print(error)
        }
        

    }
    
    internal func getPostRequest(url : NSURL ,body : AnyObject) ->  NSMutableURLRequest
    {
        
      
    
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            
            // create post request
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue((appDel.services?.getToken())!, forHTTPHeaderField: "Authorization")
            
            return request
        }catch
        {
            return NSMutableURLRequest()
        }

        
        
    }
    
    internal func makePutRequest(url : NSURL ,body : AnyObject,objClass : String,funcName :String)
    {
        do {
           
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            
            // create post request
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "PUT"
            
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue((appDel.services?.getToken())!, forHTTPHeaderField: "Authorization")
            
            
            defer{
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    
                    if let httpResponse = response as? NSHTTPURLResponse {
                        
                        let code = httpResponse.statusCode
                        print(code)
                        var pt : MyProtocol
                        pt = MyProtocol.init()
                        pt.putRequestFinished(httpResponse.statusCode, dic: data!,objClass: objClass,funcName: funcName)
                        print(" passed 1" )
                        
                    }else
                    {
                        
                    }
                    
                    if error != nil{
                        
                        print(error)
                        return
                    }
                    
                }
                
                task.resume()
                print("task done")}
        } catch {
            print(error)
        }
    }
    
    internal func makeGetRequest(url : NSURL,objClass : String,funcName : String,extra : AnyObject)
    {
        
        
        defer
        {
            let url = url

            let request = NSMutableURLRequest(URL: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") //Optional
            
            if funcName == "legacyUser"
            {
                request.addValue( "Basic " + (extra as! String), forHTTPHeaderField: "Authorization")
            }
            request.HTTPMethod = "GET"
            let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
            
            defer{
            let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    var pt : MyProtocol
                    pt = MyProtocol.init()
                    pt.getRequestFinished(httpResponse.statusCode, dic: data!,objClass: objClass,funcName: funcName)
                    print(" passed 1" )
                    
                }else
                {
                    
                }
                
                if error != nil{
                    
                    print(error)
                    return
                }

            }
            dataTask.resume()
            }
        }
    }
    
    
}