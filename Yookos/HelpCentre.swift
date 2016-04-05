//
//  HelpCentre.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/07.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation

class HelpCentre: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate{
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtDevice: UITextField!
    @IBOutlet var vwContent: UIView!
    
    @IBOutlet var vwProblem: UIView!
    @IBOutlet var lblProblem: UILabel!
    @IBOutlet var lblProblemDrop: UILabel!
    @IBOutlet var txtMore: UITextView!
    
    var pickOption :[String] = ["Login","Sign up","Verification link","Verification sms","Forgot password"]
    var pickerView : UIPickerView?
    
    @IBOutlet var txtProbInput: UITextField? = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ADDING TAB GESTURE TO ALL VIEWS
        let tap = UITapGestureRecognizer(target: self, action: #selector(HelpCentre.problemTap(_:)))
        vwProblem.addGestureRecognizer(tap)
        
        // ADD A TOOLBAR WITH A DONE BUTTON
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.barTintColor = Color.init().pickerBarColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HelpCentre.donePicking(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
        //CREATE A PICKER AND ASSIGN IT AS INPUT OF A TEXTFIELd
        pickerView = UIPickerView()
        pickerView!.delegate = self
        pickerView!.dataSource = self
        pickerView!.sizeToFit()
    
        txtProbInput!.inputView = pickerView
        txtProbInput!.inputAccessoryView = toolBar
        
        vwProblem!.layer.borderColor = Color.init().viewBorderColor()
        vwProblem!.layer.borderWidth = 1.0
        txtProbInput!.layer.borderColor = Color.init().viewBorderColor()
        txtProbInput!.layer.borderWidth = 1.0
        txtMore!.layer.borderColor = Color.init().viewBorderColor()
        txtMore!.layer.borderWidth = 1.0
        
        vwContent.addSubview(txtProbInput!)
        
        //APPLYING FONT-AWESOME TO ALL COMPONANTS THAT USE SPECIAL FONTTS
        lblProblemDrop.FAIcon = FAType.FAGithub
        lblProblemDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblProblemDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func report(sender: AnyObject) {
        
        
        if txtEmail.text == ""
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Email", message:"Please enter Email", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
            
            return
        }
        
        if txtDevice.text == ""
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Divice name", message:"Please enter the name of the device and the OS version", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
            
            return
        }
        if lblProblem.text == "Select"
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Error", message:"Please select what problem you having", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
            
            return
        }
        
        if txtMore.text == ""
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Error", message:"Please tell us a bit more about your problem", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
            
            return
        }
        
        let json : [String: AnyObject] = [ "email"  : txtEmail.text!,"reason" : lblProblem.text!,"description" : txtMore.text,"platform": txtDevice.text!]
        
        let request = HttpRequest().getRequest(Services().help(), body: json ,method: "POST")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                let code = httpResponse.statusCode
                print(code)
                
                if code == 200
                {
                    
                    defer {
                        dispatch_async( dispatch_get_main_queue(),{
                            let alert = UIAlertController(title: "Thank you", message:"Thank you for your feedback,we will send you a response within 24 hours.", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                            UIViewController.topMostController().presentViewController(alert, animated: true){}
                        })
                    }

                    
                    
                }else if code == 400
                {
                    defer {
                        dispatch_async( dispatch_get_main_queue(),{
                            let alert = UIAlertController(title: "ERROR", message:"Please make sure you entered a valid email or an email that we know of.", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                            UIViewController.topMostController().presentViewController(alert, animated: true){}
                        })
                    }
                }else
                {
                    defer {
                        dispatch_async( dispatch_get_main_queue(),{
                            let alert = UIAlertController(title: "ERROR", message:"Please make sure you entered a valid email or an email that we know of.", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                            UIViewController.topMostController().presentViewController(alert, animated: true){}
                        })
                    }
                }
                
                print(" passed 1" )
                
            }else
            {
                defer {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR", message:"ooops looks like we experiencing some problems", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                }
            }
            
            if error != nil{
                
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "ERROR", message:"Network Connection Lost", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
                return
            }
            
        }
        
        task.resume()
        
        
        print("task done")
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
         self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*############################################################################################
    
    ------>  ---->  WHEN PICKER APPEARS/DISAPPEARS
    
    ###########################################################################################*/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
                    return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
                        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
                        return pickOption[row]
    }
        
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        lblProblem.text = pickOption[row]
        
    }
    func donePicking(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
    }
    
    func problemTap(sender: UITapGestureRecognizer)
    {
        txtProbInput!.becomeFirstResponder()
    }
}