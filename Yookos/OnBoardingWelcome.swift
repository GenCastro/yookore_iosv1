//
//  OnBoardingWelcome.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/22.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class OnBoardingWelcome : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var lblAdd: UILabel!
    @IBOutlet var btnNext: UIBarButtonItem!
    @IBOutlet var imgView: UIImageView!
 
    var tittle = "Add Photo"
     var myPickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
        myPickerController.delegate = self
        lblAdd.text = tittle
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(OnBoardingWelcome.selectPhotoButtonTapped(_:)))
        lblAdd?.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func next(sender: AnyObject) {
        
       let url = NSURL(string: "https://upm.yookos.com/api/v1/profile/21c4baa0-9db6-4c18-acf0-2c13ab62fa51/avatar")
        let request = NSMutableURLRequest(URL:url!);
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imgView.image!, 1)
        
        request.HTTPBody = createBodyWithParameters([:], filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                let code = httpResponse.statusCode
                print(code)
                print(response)
                
                
                if code == 200
                {
                    
                    do {
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        print(json)
                        // YOUR OTHER CODE HERE
                        
                    } catch
                    {
                        print(error)
                    }
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("onboarding");
                    dispatch_async(dispatch_get_main_queue(), {
                        //Code that presents or dismisses a view controller here
                        
                        self.presentViewController(nextViewController, animated:true, completion:nil)
                    });
                    
                    
                }else
                {
                    
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "ERROR!", message:"we couldnot upload your photo", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "DISMISS", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                }
                
                print(" passed 1" )
                
            }else
            {
                
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
        
        
   }
    
    @IBAction func selectPhotoButtonTapped(sender: UITapGestureRecognizer) {
        
       
        let optionMenu = UIAlertController(title: nil, message: "Add profile photo", preferredStyle: .ActionSheet)
        
        // 2
        let takePhoto = UIAlertAction(title: "Take photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(self.myPickerController, animated: true, completion: nil)
           
        })
        let selectFromLib = UIAlertAction(title: "Select from library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(self.myPickerController, animated: true, completion: nil)
           
        })
        
      
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.lblAdd.text = self.tittle
        })
        
        

        optionMenu.addAction(takePhoto)
        optionMenu.addAction(selectFromLib)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
    }
    
     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject]) {
        print("Calling")
        
        imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height/2
        
        btnNext.enabled = true
        tittle =  "Change Photo"
        lblAdd.text = tittle
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateBoundaryString() -> String {
        return "----WebKitFormBoundaryE19zNvXGzXaLvS5C"
    }
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
}

extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}