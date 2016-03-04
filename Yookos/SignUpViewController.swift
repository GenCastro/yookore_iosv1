//
//  SignUpTableViewController.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/23.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    var appDel:AppDelegate?
    
    @IBOutlet var imgStep1: UIImageView!
    
    @IBOutlet var btnNext: UIButton!
    
    
    @IBOutlet var btnHaveProblem: UIButton!
    var attrs = [
        NSFontAttributeName : UIFont.systemFontOfSize(13.0),
        NSForegroundColorAttributeName : UIColor.blueColor(),
        NSUnderlineStyleAttributeName : 1]
    
    var attributedString = NSMutableAttributedString(string:"")
    var checkPic = ""
    
    @IBOutlet var lblFirstname: UILabel!
    @IBOutlet var lblLastname: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblConfirmEmail: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var lblMaleIcon: UILabel!
    @IBOutlet var lblMale: UILabel!
    @IBOutlet var lblFemaleICon: UILabel!
    @IBOutlet var lblFemale: UILabel!
    
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblDayDrop: UILabel!
    @IBOutlet var lblMonth: UILabel!
    @IBOutlet var lblMonthDrop: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblYearDrop: UILabel!
    @IBOutlet var lblOR: UILabel!
    
    @IBOutlet var lblErrorMsg: UILabel!
   
    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtConfirmEmail: UITextField!
    
    @IBOutlet var activeField: UITextField!
    
    @IBOutlet var vwDY: UIView!
    @IBOutlet var vwMonth: UIView!
    @IBOutlet var vwYear: UIView!
    @IBOutlet var vwMale: UIView!
    @IBOutlet var vwFemale: UIView!
    @IBOutlet var theView: UIView!
    @IBOutlet var vwSignupWith: UIView!
    @IBOutlet var vwMainView: UIView!
    @IBOutlet var vwError: UIView!
    
    @IBOutlet var scroller: UIScrollView!

    var pickOption :[String] = []
    var txtDateInput :UITextField = UITextField()
    
    var pickerView:UIPickerView!
    
    var nameVer : Bool = false
    var lastnameVer : Bool = false
    var emailVer : Bool = false
    var dateVer : Bool = false
    var gender : Bool = false
    var day : String = ""
    var month : String = ""
    var year : String = ""
    
    @IBAction func back(sender: UIBarButtonItem) {
        
       self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
      
        
        //DEALING WITH SCROLLING ACTIVITIES
        
        scroller = UIScrollView(frame: view.bounds)
        scroller!.contentSize = theView.bounds.size
        scroller!.autoresizingMask = UIViewAutoresizing.FlexibleHeight

        vwMainView.addSubview(scroller!)
        scroller!.addSubview(theView)
        theView.addSubview(txtDateInput)
       
        //ADDING TAB GESTURE TO ALL VIEWS
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("dayTap:"))
        vwDY.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: Selector("monthTap:"))
        vwMonth.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: Selector("yearTap:"))
        vwYear.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: Selector("maleTap:"))
        vwMale.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: Selector("femaleTap:"))
        vwFemale.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: Selector("signWithTap:"))
        vwSignupWith.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: Selector("closeErrorTap:"))
        lblErrorMsg.addGestureRecognizer(tap)
        
        
        // ADD A TOOLBAR WITH A DONE BUTTON
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.barTintColor = UIColor.blueColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicking:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
        //CREATE A PICKER AND ASSIGN IT AS INPUT OF A TEXTFIELD
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.sizeToFit()
        
        txtDateInput.addTarget(self, action: "dateInput:", forControlEvents: UIControlEvents.EditingDidBegin)
        txtDateInput.inputView = pickerView
        txtDateInput.inputAccessoryView = toolBar
        
        //APPLYING FONT-AWESOME TO ALL COMPONANTS THAT USE SPECIAL FONTTS
     
        lblDayDrop.FAIcon = FAType.FAGithub
        lblDayDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblDayDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblMonthDrop.FAIcon = FAType.FAGithub
        lblMonthDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblMonthDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        lblYearDrop.FAIcon = FAType.FAGithub
        lblYearDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblYearDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblYearDrop.FAIcon = FAType.FAGithub
        lblYearDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblYearDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblFemaleICon.FAIcon = FAType.FAGithub
        lblFemaleICon.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblFemaleICon.setFAText(prefixText: "", icon: FAType.FACircleThin, postfixText: "", size: 15)
        lblFemaleICon.textColor = UIColor.lightGrayColor()
        
        lblMaleIcon.textColor = UIColor.blueColor()
        lblMaleIcon.FAIcon = FAType.FAGithub
        lblMaleIcon.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblMaleIcon.setFAText(prefixText: "", icon: FAType.FACheckCircle, postfixText: "", size: 15)
        
        //ADDING BORDERS TO THE DATE VIEWS
        vwDY.layer.borderColor = UIColor.lightGrayColor().CGColor
        vwDY.layer.borderWidth = 2.0
        vwMonth.layer.borderColor = UIColor.lightGrayColor().CGColor
        vwMonth.layer.borderWidth = 2.0
        vwYear.layer.borderColor = UIColor.lightGrayColor().CGColor
        vwYear.layer.borderWidth = 2.0
        
        let color2 = UIColor(netHex:0x03A9F4)
        vwSignupWith.layer.borderColor = color2.CGColor
        vwSignupWith.layer.borderWidth = 2.0
        
        let buttonTitleStr = NSMutableAttributedString(string:"having a problem with signing up?", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        btnHaveProblem.setAttributedTitle(attributedString, forState: .Normal)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scroller!.contentSize = CGSize(width: 320, height: 900)
        txtFirstname.delegate = self
        txtLastname.delegate = self
        txtEmail.delegate = self
        txtConfirmEmail.delegate = self
    }
    
    /*############################################################################################
    
    ------>  ---->  WHEN VIEWS ARE TAPPED
    
    ###########################################################################################*/
    
    func dayTap(sender: UITapGestureRecognizer? = nil) {
        
        checkPic = "day"
        pickOption = []
        for var i = 1;i < 32;i++
        {
            pickOption.append(String(i))
        }
        pickerView.selectRow(pickOption.indexOf("15")!, inComponent: 0, animated: true)
        day = "15"
        
        txtDateInput.becomeFirstResponder()
        lblDay.text = day
    }
    
    func monthTap(sender: UITapGestureRecognizer? = nil) {
        
        checkPic = "month"
        pickOption = []
        pickOption = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        pickerView.selectRow(pickOption.indexOf("June")!, inComponent: 0, animated: true)
        month = "june"
        
        txtDateInput.becomeFirstResponder()
        lblMonth.text = month
    }
    func yearTap(sender: UITapGestureRecognizer? = nil) {
        
        checkPic = "year"
        pickOption = []
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let yr =  components.year

        let x = yr - 1900
        
        for var i = 0;i < x;i++
        {
          pickOption.append(String(1900 + i))
        }
        pickerView.selectRow(pickOption.indexOf("1992")!, inComponent: 0, animated: true)
        year = "1992"
        
        txtDateInput.becomeFirstResponder()
        lblYear.text = year
    }
    
    func donePicking(sender: UIBarButtonItem) {
        
        if checkPic == "year"
        {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let yr =  components.year
            let x = Int(year)
            if yr - x!  < 13
            {
                defer {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Age Restriction", message:"You ar ineligible to register an account on Yookos.For you to register an account on Yookos you need to be at least 13 years old", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    })
                }
            }
        }
        self.view.endEditing(true)
    }
    func signWithTap(sender: UITapGestureRecognizer? = nil) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
//        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func haveProblem(sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func femaleTap(sender: UITapGestureRecognizer? = nil) {
        
        
            lblMaleIcon.FAIcon = FAType.FAGithub
            lblMaleIcon.setFAIcon(FAType.FAGithub, iconSize: 15)
            lblMaleIcon.setFAText(prefixText: "", icon: FAType.FACircleThin, postfixText: "", size: 15)
            lblMaleIcon.textColor = UIColor.lightGrayColor()
            
            lblFemaleICon.textColor = UIColor.blueColor()
            lblFemaleICon.FAIcon = FAType.FAGithub
            lblFemaleICon.setFAIcon(FAType.FAGithub, iconSize: 15)
            lblFemaleICon.setFAText(prefixText: "", icon: FAType.FACheckCircle, postfixText: "", size: 15)
        
    }
    func maleTap(sender: UITapGestureRecognizer? = nil) {
        
        
        lblFemaleICon.FAIcon = FAType.FAGithub
        lblFemaleICon.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblFemaleICon.setFAText(prefixText: "", icon: FAType.FACircleThin, postfixText: "", size: 15)
        lblFemaleICon.textColor = UIColor.lightGrayColor()
        
        lblMaleIcon.textColor = UIColor.blueColor()
        lblMaleIcon.FAIcon = FAType.FAGithub
        lblMaleIcon.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblMaleIcon.setFAText(prefixText: "", icon: FAType.FACheckCircle, postfixText: "", size: 15)
        
    }
    
    func closeErrorTap(sender: UITapGestureRecognizer? = nil) {
        
        
        vwError.hidden = true
        
    }
    
    
    /*############################################################################################
    
    ------>  ---->  WHEN TEXTFIELDS ARE ACTIVE

    ###########################################################################################*/
    
    @IBAction func validateName(sender: UITextField) {
        
        
        let chk = checkAlphabet(sender.text!)
        
    
        if chk == "0"
        {
            
        }else if chk == "1"
        {
            var msg = ""
            if sender.isEqual(txtFirstname)
            {
                msg = "First name is required"
            }else if sender.isEqual(txtLastname)
            {
                 msg = "last name is required"
            }
            
            lblErrorMsg.FAIcon = FAType.FAGithub
            lblErrorMsg.setFAIcon(FAType.FAGithub, iconSize: 17)
            lblErrorMsg.setFAText(prefixText: "", icon: FAType.FAClose, postfixText: msg, size: 12)
            vwError.hidden = false
            
        }else if chk == "2"
        {
            defer{
            dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                
                let alert = UIAlertController(title: "Name", message:"your message", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                alert.message = "Please enter Name and Surname with less than 20 alphabetical charcters"
                self.presentViewController(alert, animated: true){}
            })}
            sender.becomeFirstResponder()
        }else if chk == "3"
        {
            
            
            defer{
            dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                //this place to call segue or manually load the view.
                let alert = UIAlertController(title: "Name", message:"your message", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                alert.message = "PLease enter only alphabetical letters in the name and surname fields."
                self.presentViewController(alert, animated: true){}
            })}
            
            sender.becomeFirstResponder()
        }
        
    }
    @IBAction func verEmail(sender: UITextField) {
        
        activeField = sender
        
        if sender.text == ""
        {
            lblErrorMsg.FAIcon = FAType.FAGithub
            lblErrorMsg.setFAIcon(FAType.FAGithub, iconSize: 17)
            lblErrorMsg.setFAText(prefixText: "", icon: FAType.FAClose, postfixText: "\tEmail address is required", size: 12)
            vwError.hidden = false
            sender.becomeFirstResponder()
        }else
        {
            let x = validateEmail(txtEmail.text!)
            
            if x == false
            {
                defer {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Email", message:"The email address you have entered is invalid. please enter a valid email address.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    }) 
                }
                
                sender.becomeFirstResponder()
                
            }else
            {
                let url = appDel?.services.validateEmail()
                
                let json : [String: AnyObject] = [ "email"  : sender.text!]
                appDel?.httpRequest.makePostRequest(url!, body: json, objClass: "signup", funcName: "verEmail")
            }
        }
        
        
    }
    
    @IBAction func emailMatch(sender: AnyObject) {
        
        if txtEmail.text != txtConfirmEmail.text
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Email", message:"Email address do not match.Please enter the email addresses again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                })
            }
        }
        
        
    }
    @IBAction func addName(sender: UITextField) {
       
        activeField = sender
    }
    
    @IBAction func addLastname(sender: UITextField) {
       
        activeField = sender
    }

    @IBAction func checkEmail(sender: UITextField) {
       
        activeField = sender
        
    }
    @IBAction func confirmEmail(sender: UITextField) {
        
        activeField = sender
        
    }
    
    @IBAction func dateInput(sender: UITextField) {
        
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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("signup2") as! SignUpStepTwoView
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    

    
    
    /*############################################################################################
    
    ------>  ---->  WHEN KEYBOARD APPEARS/DISAPPEARS
    
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
        
        
//        if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
//        {
//            self.scroller.scrollRectToVisible(activeField.frame, animated: true)
//        }
        
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
       
        self.view.endEditing(true)
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
        
        if checkPic == "day"
        {
              lblDay.text = pickOption[row]
              day = lblDay.text!
        }else if checkPic == "month"
        {
            lblMonth.text = pickOption[row]
            month = lblMonth.text!
        }else if checkPic == "year"
        {
            lblYear.text = pickOption[row]
            year = lblYear.text!
        }
        
    }
    
    /*############################################################################################
    
    ------>  ---->  INPUT VERIFICATIONS
    
    ###########################################################################################*/
    
    func checkAlphabet(chk_txt:String) -> String
    {
        let length = chk_txt.characters.count
        if length == 0
        {
            return "1"
        }else if length > 20
        {
            return "2"
        }else
        {
            for chr in chk_txt.characters{
                
                if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ){
                    return "3"
                }
            }
            return "0"
        }
        
    }
    
    func receiveRequest(code :Int,response :AnyObject,funcName : String)
    {
        if funcName == "verEmail"
        {
            if code == 200
            {
                print("USer found")
            }else if code == 406
            {
                print("Unsupported request")
            }else if code == 400
            {
                print("bad request")
            }else if code == 401
            {
                print("Unauthorized")
            }else if code == 404
            {
                
                print("not found")
                
            }
        }
    }
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
