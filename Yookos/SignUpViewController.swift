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
    
    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtConfirm: UITextField!
    
    var activeField: UITextField!
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnSignUpWith: UIButton!
    @IBOutlet var btnHaveProblem: UIButton!
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblSurname: UILabel!
    @IBOutlet var lblConfirm: UILabel!
    @IBOutlet var lblOr: UILabel!
    @IBOutlet var lbFirstname: UILabel!
    @IBOutlet var lblLine1: UILabel!
    @IBOutlet var lblLine2: UILabel!
    
    @IBOutlet var scroller: UIScrollView!
    @IBOutlet var dpDate: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
      
        
        scroller = UIScrollView(frame: view.bounds)
        scroller.backgroundColor = UIColor.blackColor()
        
        scroller.contentSize = view.bounds.size
        scroller.contentSize.height = 650
        scroller.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        scroller.addSubview(navBar)
        
        scroller.addSubview(imgView)
        
        scroller.addSubview(txtFirstname)
        scroller.addSubview(txtLastname)
        scroller.addSubview(txtEmail)
        scroller.addSubview(txtConfirm)
        
        scroller.addSubview(lblEmail)
        scroller.addSubview(lbFirstname)
        scroller.addSubview(lblConfirm)
        scroller.addSubview(lblOr)
        scroller.addSubview(lblSurname)
        scroller.addSubview(lblLine1)
        scroller.addSubview(lblLine2)
        
        scroller.addSubview(btnNext)
        scroller.addSubview(btnSignUpWith)
        scroller.addSubview(btnHaveProblem)
        scroller.backgroundColor = UIColor.clearColor()
        
        view.addSubview(scroller)
        
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        view.addGestureRecognizer(tap)

    }
    
    /*#############################################################################################             
    
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
    
    
    /*#############################################################################################
    
    ------>  ---->  WHEN BUTTONS ARE CLICKED
    
    ###########################################################################################*/
    @IBAction func nextStep(sender: UIButton) {
    }
    
    @IBAction func signUpWith(sender: UIButton) {
    }
    @IBAction func haveProblem(sender: UIButton) {
    }
    
    
    /*#############################################################################################
    
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
}
