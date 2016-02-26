//
//  SignUpTableViewController.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/23.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var imgStep1: UIImageView!
    
    @IBOutlet var lblFirstname: UILabel!
    @IBOutlet var lblLastname: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblConfirmEmail: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblMaleGen: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtConfirmEmail: UITextField!
    
    @IBOutlet var activeField: UITextField!
    
    @IBOutlet var vwDY: UIView!
    @IBOutlet var vwMonth: UIView!
    @IBOutlet var vwYear: UIView!
    @IBOutlet var theView: UIView!
    
    @IBOutlet var scroller: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
      
        
        //view.addSubview(scroller)
        
        scroller = UIScrollView(frame: view.bounds)
        scroller!.contentSize = theView.bounds.size
        scroller!.autoresizingMask = UIViewAutoresizing.FlexibleHeight


        theView.addSubview(scroller!)
        
        scroller!.addSubview(imgStep1)
        
                scroller!.addSubview(txtFirstname)
                scroller!.addSubview(txtLastname)
                scroller!.addSubview(txtEmail)
                scroller!.addSubview(txtConfirmEmail)
        
                scroller!.addSubview(lblEmail)
                scroller!.addSubview(lblFirstname)
                scroller!.addSubview(lblConfirmEmail)
                scroller!.addSubview(lblGender)
                scroller!.addSubview(lblLastname)
                scroller!.addSubview(lblDate)
                scroller!.addSubview(lblMaleGen)
        
                scroller!.addSubview(vwDY)
                scroller!.addSubview(vwYear)
                scroller!.addSubview(vwMonth)
       

        lblMaleGen.FAIcon = FAType.FAGithub
        
        lblMaleGen.setFAIcon(FAType.FAGithub, iconSize: 10)
        
        lblMaleGen.setFAText(prefixText: "follow me on ", icon: FAType.FATwitter, postfixText: ". Thanks!", size: 10)
        

    }
    
    /*############################################################################################             
    
    ------>  ---->  WHEN TEXTFIELDS ARE ACTIVE

    ###########################################################################################*/
    
    @IBAction func addName(sender: UITextField) {
       
        activeField = sender
    }
    @IBAction func addLastname(sender: UITextField) {
       
        activeField = sender
    }

    @IBAction func checkEmail(sender: UITextField) {
       
        activeField = sender
        
       let x = validateEmail(txtEmail.text!)
        
        if x == false{
            lblEmail.text = "invalid email"
            lblEmail.textColor = UIColor.redColor()
        }else
        {
            lblEmail.text = "Email address"
            lblEmail.textColor = UIColor.blackColor()
        }
    }

    @IBAction func confirmEmail(sender: UITextField) {
        
        activeField = sender
        
    }

    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    
    /*############################################################################################
    
    ------>  ---->  WHEN BUTTONS ARE CLICKED
    
    ###########################################################################################*/
    @IBAction func nextStep(sender: UIButton) {
    }
    
    @IBAction func signUpWith(sender: UIButton) {
    }
    @IBAction func haveProblem(sender: UIButton) {
    }
    
    
    /*############################################################################################
    
    ------>  ---->  WHEN KEYBOARD IS APPEARS/DISAPPEARS
    
    ###########################################################################################*/
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
       
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0,offset.height, 0.0);
        
        
        scroller.contentInset = contentInsets;
        scroller.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame;
        aRect.size.height -= offset.height;
        
        
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
        {
            self.scroller.scrollRectToVisible(activeField.frame, animated: true)
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero;
        scroller.contentInset = contentInsets;
        scroller.scrollIndicatorInsets = contentInsets;
    }
    func textFieldDidBeginEditing(txtField :UITextField )
    {
            activeField = txtField
    }
    
    func textFieldDidEndEditing(txtField :UITextField )
    {
            activeField = nil;
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
       
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scroller!.contentSize = CGSize(width: 320, height: 700)
    }
}
