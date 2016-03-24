//
//  OnBoardingWelcome.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/22.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit
import Alamofire

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
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("selectPhotoButtonTapped:"))
        lblAdd?.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func next(sender: AnyObject) {
        
        let imageData = UIImageJPEGRepresentation(imgView.image!, 0.5)
        let url = Services().uploadProfileAvatar("21c4baa0-9db6-4c18-acf0-2c13ab62fa51")
        
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        
        let parameters = ["file": base64String] as [String: AnyObject]
        _ = Alamofire.request(.POST, url, parameters: parameters)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                //  To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)....\(totalBytesExpectedToWrite)")
                }
            }
            .responseJSON {  response in
                debugPrint(response)
                if response.result.isSuccess {
                    print("here")
                }
                else{
                    print("here")
                }
                
        }
        
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