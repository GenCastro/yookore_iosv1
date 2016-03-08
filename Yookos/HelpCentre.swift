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
        let tap = UITapGestureRecognizer(target: self, action: Selector("problemTap:"))
        vwProblem.addGestureRecognizer(tap)
        
        // ADD A TOOLBAR WITH A DONE BUTTON
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.barTintColor = Color.init().pickerBarColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicking:")
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
        
        vwProblem!.layer.borderColor = Color.init().viewBorderColor().CGColor
        vwProblem!.layer.borderWidth = 2.0
        
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