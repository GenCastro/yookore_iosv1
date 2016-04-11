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
            
             let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("popover")
             
             self.providesPresentationContextTransitionStyle = true;
             self.definesPresentationContext = true;
             self.presentViewController(popoverVC!, animated: false, completion: nil)
            defer{
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                dispatch_async(dispatch_get_main_queue(),{
                popoverVC?.dismissViewControllerAnimated(false, completion: {
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
                })
                })
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
    
    /*
     
     appDel = UIApplication.sharedApplication().delegate as? AppDelegate
     
     if appDel?.profile.nameVer! == true && appDel?.profile.lastnameVer! == true && appDel?.profile.email != "" && appDel?.profile.emailMatch! == true && appDel?.profile.day! != "" && appDel?.profile.month! != "" && appDel?.profile.year! != ""
     {
     self.view!.userInteractionEnabled = false
     
     let url = appDel?.services.validateEmail()
     let json : [String: AnyObject] = [ "email"  : (appDel?.profile.email)!]
     let request = HttpRequest().getRequest(url!, body: json,method: "POST")
     
     let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
     
     self.view!.userInteractionEnabled = true
     if let httpResponse = response as? NSHTTPURLResponse {
     
     let code = httpResponse.statusCode
     print(code)
     
     if code == 200
     {
     print("email found")
     self.txtEmail?.layer.borderWidth = 0
     self.appDel?.profile.emailVer! = true
     
     let dateFormatter = NSDateFormatter()
     dateFormatter.dateFormat = "dd-MMMM-yyyy"
     self.appDel = UIApplication.sharedApplication().delegate as? AppDelegate
     let day = self.appDel?.profile.day!
     let month = self.appDel?.profile.month!
     let year = self.appDel?.profile.year!
     
     let date = dateFormatter.dateFromString(day! + "-" + month! + "-" + year!)
     
     let timeStamp = date?.timeIntervalSince1970
     self.appDel?.profile.birthdate = timeStamp
     self.appDel?.profile.dateOfBirth = dateFormatter.stringFromDate(date!)
     
     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
     let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("signup2") as! SignUpStepTwoView
     self.presentViewController(nextViewController, animated:true, completion:nil)
     
     }else if code == 406
     {
     
     print("Unsupported request")
     dispatch_after(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "Error!!", message: "We couldnot continue with your request,please try again or contact help centre", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { _ in
     
     self.view.userInteractionEnabled = true
     
     })
     
     UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
     
     
     })
     
     }else if code == 400
     {
     
     print("bad request")
     
     }else if code == 401
     {
     
     print("Unauthorized")
     dispatch_async(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "Error!!", message: "We couldnot continue with your request,please try again or contact help centre", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { _ in
     
     self.view.userInteractionEnabled = true
     
     })
     
     UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
     
     
     })
     
     }else if code == 404
     {
     
     print("not found")
     
     dispatch_async(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "Error!!", message: "either the email doesnot exist or the email have been used on yookos before,please verify", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { _ in
     
     self.view.userInteractionEnabled = true
     self.txtEmail?.layer.borderColor = UIColor.redColor().CGColor
     self.txtEmail?.layer.borderWidth = 1
     self.txtEmail?.becomeFirstResponder()
     })
     
     UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
     
     
     })
     
     }else
     {
     dispatch_after(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "Error!!", message: "We couldnot continue with your request,please try again or contact help centre", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { _ in
     
     self.view.userInteractionEnabled = true
     
     })
     
     UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
     
     
     })
     }
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
     
     
     }else if appDel?.profile.nameVer! == false
     {
     validateName(txtFirstname!)
     txtFirstname?.becomeFirstResponder()
     txtFirstname?.layer.borderWidth = 1
     txtFirstname?.layer.borderColor = UIColor.redColor().CGColor
     }else if appDel?.profile.lastnameVer! == false
     {
     validateName(txtLastname!)
     txtLastname?.becomeFirstResponder()
     txtLastname?.layer.borderWidth = 1
     txtLastname?.layer.borderColor = UIColor.redColor().CGColor
     }else if txtEmail?.text == ""
     {
     verEmail(txtEmail!)
     txtEmail?.becomeFirstResponder()
     txtEmail?.layer.borderWidth = 1
     txtEmail?.layer.borderColor = UIColor.redColor().CGColor
     
     }else if appDel?.profile.emailMatch! == false
     {
     emailMatch(txtConfirmEmail!)
     txtConfirmEmail?.becomeFirstResponder()
     txtConfirmEmail?.layer.borderWidth = 1
     txtConfirmEmail?.layer.borderColor = UIColor.redColor().CGColor
     }else
     {
     if appDel?.profile.day! == ""
     {
     dispatch_after(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "DATE!!", message: "You did not select day", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
     
     self.vwDY?.layer.borderColor = UIColor.redColor().CGColor
     self.checkPic = "day"
     
     })
     self.presentViewController(alert, animated: true, completion: nil)
     
     })
     
     }else if appDel?.profile.month! == ""
     {
     dispatch_after(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "DATE!!", message: "You did not select month", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
     
     self.vwMonth?.layer.borderColor = UIColor.redColor().CGColor
     self.checkPic = "month"
     
     
     })
     self.presentViewController(alert, animated: true, completion: nil)
     
     })
     }else if appDel?.profile.year! == ""
     {
     dispatch_after(1, dispatch_get_main_queue(),{
     
     let alert = UIAlertController(title: "DATE!!", message: "You did not select year", preferredStyle: UIAlertControllerStyle.Alert)
     alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
     
     self.vwYear?.layer.borderColor = UIColor.redColor().CGColor
     self.checkPic = "year"
     
     })
     self.presentViewController(alert, animated: true, completion: nil)
     
     })
     
     
     }
     
     }
     
     */
    
    
}