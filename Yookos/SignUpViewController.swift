//
//  SignUpTableViewController.swift
//  YKSIA
//
//  Created by Zwelithini Mathebula on 2016/02/23.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,UIScrollViewDelegate {
    
    var appDel:AppDelegate?
    
    @IBOutlet var imgStep1: UIImageView?
    
    @IBOutlet var btnNext: UIButton?
    
    
    @IBOutlet var btnHaveProblem: UIButton?
    var attrs = [
        NSFontAttributeName : UIFont.systemFontOfSize(13.0),
        NSForegroundColorAttributeName : UIColor.blueColor(),
        NSUnderlineStyleAttributeName : 1]
    
    var attributedString = NSMutableAttributedString(string:"")
    var checkPic = ""
    
    @IBOutlet var lblFirstname: UILabel?
    @IBOutlet var lblLastname: UILabel?
    @IBOutlet var lblEmail: UILabel?
    @IBOutlet var lblConfirmEmail: UILabel?
    @IBOutlet var lblGender: UILabel?
    @IBOutlet var lblDate: UILabel?
    
    @IBOutlet var lblMaleIcon: UILabel?
    @IBOutlet var lblMale: UILabel?
    @IBOutlet var lblFemaleICon: UILabel?
    @IBOutlet var lblFemale: UILabel?
    
    @IBOutlet var lblDay: UILabel?
    @IBOutlet var lblDayDrop: UILabel?
    @IBOutlet var lblMonth: UILabel?
    @IBOutlet var lblMonthDrop: UILabel?
    @IBOutlet var lblYear: UILabel?
    @IBOutlet var lblYearDrop: UILabel?
    @IBOutlet var lblOR: UILabel?
    @IBOutlet var lblLeftLine: UILabel!
    @IBOutlet var lblRightLine: UILabel!
    
    @IBOutlet var lblErrorMsg: UILabel?
   
    @IBOutlet var txtFirstname: UITextField?
    @IBOutlet var txtLastname: UITextField?
    @IBOutlet var txtEmail: UITextField?
    @IBOutlet var txtConfirmEmail: UITextField?
    
     @IBOutlet var activeField: UITextField?
    
    @IBOutlet var vwDY: UIView?
    @IBOutlet var vwMonth: UIView?
    @IBOutlet var vwYear: UIView?
    @IBOutlet var vwMale: UIView?
    @IBOutlet var vwFemale: UIView?
    @IBOutlet var theView: UIView?
    @IBOutlet var vwSignupWith: UIView?
    @IBOutlet var vwMainView: UIView?
    @IBOutlet var vwError: UIView?
    
    
    @IBOutlet var scroller: UIScrollView?
    
    var years :[String] = []
    var days :[String] = []
    var months :[String ] = []
    
    var txtDateInput :UITextField = UITextField()
    
    var pickerView:UIPickerView?

    
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
       
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view?.endEditing(true)
       
        theView?.addSubview(txtDateInput)
        //
        //
        let specsScrollViewConstY = NSLayoutConstraint(item: scroller,
            attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: btnHaveProblem, attribute: NSLayoutAttribute.Bottom, multiplier: 1,
            constant: 10);
        
        scroller?.addConstraint(specsScrollViewConstY);
     
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year - 14
        
        let x = year - 1900
        
        for i in 0 ..< x
        {
            years.append(String(year - i))
        }
        
        for i in 1 ..< 32
        {
            days.append(String(i))
        }
        
        months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        //ADDING TAB GESTURE TO ALL VIEWS
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dayTap(_:)))
        vwDY?.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.monthTap(_:)))
        vwMonth?.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.yearTap(_:)))
        vwYear?.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.maleTap(_:)))
        vwMale?.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.femaleTap(_:)))
        vwFemale?.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.signWithTap(_:)))
        vwSignupWith?.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.closeErrorTap(_:)))
        lblErrorMsg?.addGestureRecognizer(tap)
        
        
        // ADD A TOOLBAR WITH A DONE BUTTON
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.barTintColor = Color.init().pickerBarColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignUpViewController.donePicking(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
        //CREATE A PICKER AND ASSIGN IT AS INPUT OF A TEXTFIELD
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.sizeToFit()
        
        txtDateInput.addTarget(self, action: #selector(SignUpViewController.dateInput(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        txtDateInput.inputView = pickerView
        txtDateInput.inputAccessoryView = toolBar
        
        //APPLYING FONT-AWESOME TO ALL COMPONANTS THAT USE SPECIAL FONTTS
        
        lblDayDrop?.FAIcon = FAType.FAGithub
        lblDayDrop?.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblDayDrop?.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblMonthDrop?.FAIcon = FAType.FAGithub
        lblMonthDrop?.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblMonthDrop?.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        lblYearDrop?.FAIcon = FAType.FAGithub
        lblYearDrop?.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblYearDrop?.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblYearDrop?.FAIcon = FAType.FAGithub
        lblYearDrop?.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblYearDrop?.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblFemaleICon?.FAIcon = FAType.FAGithub
        lblFemaleICon?.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblFemaleICon?.setFAText(prefixText: "", icon: FAType.FACircleThin, postfixText: "", size: 15)
        lblFemaleICon?.textColor = UIColor.lightGrayColor()
        
        lblMaleIcon?.textColor = UIColor.blueColor()
        lblMaleIcon?.FAIcon = FAType.FAGithub
        lblMaleIcon?.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblMaleIcon?.setFAText(prefixText: "", icon: FAType.FACheckCircle, postfixText: "", size: 15)
        
        //ADDING BORDERS TO THE DATE VIEWS
        vwDY?.layer.borderColor = Color.init().viewBorderColor()
        vwDY?.layer.borderWidth = 2.0
        vwMonth?.layer.borderColor = Color.init().viewBorderColor()
        vwMonth?.layer.borderWidth = 2.0
        vwYear?.layer.borderColor = Color.init().viewBorderColor()
        vwYear?.layer.borderWidth = 2.0
        
        vwSignupWith?.layer.borderColor = Color.init().fbColor().CGColor
        vwSignupWith?.layer.borderWidth = 2.0
        
        
        let buttonTitleStr = NSMutableAttributedString(string:"having a problem with signing up?", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        btnHaveProblem?.setAttributedTitle(attributedString, forState: .Normal)

        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scroller?.contentSize = CGSize(width: self.view.bounds.width, height: 800)
        txtFirstname?.delegate = self
        txtLastname?.delegate = self
        txtEmail?.delegate = self
        txtConfirmEmail?.delegate = self
    }
    
    /*############################################################################################
    
    ------>  ---->  WHEN VIEWS ARE TAPPED
    
    ###########################################################################################*/
    
    func dayTap(sender: UITapGestureRecognizer? = nil) {
        
        theView!.userInteractionEnabled = false
        checkPic = "day"

        
        pickerView!.selectRow(days.indexOf("15")!, inComponent: 0, animated: true)
        appDel?.profile.day! = "15"
        
        txtDateInput.becomeFirstResponder()
        lblDay!.text = appDel?.profile.day!
        vwDY?.layer.borderColor = Color().viewBorderColor()
    }
    
    func monthTap(sender: UITapGestureRecognizer? = nil) {
        
        theView!.userInteractionEnabled = false
        checkPic = "month"
        
        pickerView!.selectRow(months.indexOf("June")!, inComponent: 0, animated: true)
        appDel?.profile.month! = "June"
        
        txtDateInput.becomeFirstResponder()
        lblMonth!.text = appDel?.profile.month!
        appDel?.profile.month = appDel?.profile.month!
        vwMonth?.layer.borderColor = Color().viewBorderColor()
    }
    func yearTap(sender: UITapGestureRecognizer? = nil) {
        
        theView!.userInteractionEnabled = false
        checkPic = "year"
        
        pickerView!.selectRow(years.indexOf("1998")!, inComponent: 0, animated: true)
        appDel?.profile.year! = "1998"
        
        txtDateInput.becomeFirstResponder()
        lblYear!.text = appDel?.profile.year!
        vwYear?.layer.borderColor = Color().viewBorderColor()
        
    }
    
    func donePicking(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        theView!.userInteractionEnabled = true
    }
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    //Some other options: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"
    
    @IBAction func signWithTap(sender: UITapGestureRecognizer) {
        
        
        let token = FBSDKAccessToken.currentAccessToken()
        
        if token != nil
        {
            print(FBSDKAccessToken.currentAccessToken())
        
        }else
        {
           
        }
        
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func haveProblem(sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("help");
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func femaleTap(sender: UITapGestureRecognizer? = nil) {
        
        
            lblMaleIcon!.FAIcon = FAType.FAGithub
            lblMaleIcon!.setFAIcon(FAType.FAGithub, iconSize: 15)
            lblMaleIcon!.setFAText(prefixText: "", icon: FAType.FACircleThin, postfixText: "", size: 15)
            lblMaleIcon!.textColor = UIColor.lightGrayColor()
            
            lblFemaleICon!.textColor = UIColor.blueColor()
            lblFemaleICon!.FAIcon = FAType.FAGithub
            lblFemaleICon!.setFAIcon(FAType.FAGithub, iconSize: 15)
            lblFemaleICon!.setFAText(prefixText: "", icon: FAType.FACheckCircle, postfixText: "", size: 15)
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        appDel?.profile.gender = "Female"
        
    }
    func maleTap(sender: UITapGestureRecognizer? = nil) {
        
        
        lblFemaleICon!.FAIcon = FAType.FAGithub
        lblFemaleICon!.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblFemaleICon!.setFAText(prefixText: "", icon: FAType.FACircleThin, postfixText: "", size: 15)
        lblFemaleICon!.textColor = UIColor.lightGrayColor()
        
        lblMaleIcon!.textColor = UIColor.blueColor()
        lblMaleIcon!.FAIcon = FAType.FAGithub
        lblMaleIcon!.setFAIcon(FAType.FAGithub, iconSize: 15)
        lblMaleIcon!.setFAText(prefixText: "", icon: FAType.FACheckCircle, postfixText: "", size: 15)
        
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        appDel?.profile.gender = "Male"
    }
    
    func closeErrorTap(sender: UITapGestureRecognizer? = nil) {
        
        
        vwError!.hidden = true
        
    }
    
    
    /*############################################################################################
    
    ------>  ---->  WHEN TEXTFIELDS ARE ACTIVE

    ###########################################################################################*/
    
    @IBAction func validateName(sender: UITextField) {
        
        
        let chk = checkAlphabet(sender.text!)
        
        if chk == "0"
        {
            appDel = UIApplication.sharedApplication().delegate as? AppDelegate
            if sender.isEqual(txtFirstname)
            {
                appDel?.profile.nameVer! = true
                appDel?.profile.firstname = sender.text
                self.txtFirstname?.layer.borderWidth = 0
                vwError?.hidden = true
            }else if sender.isEqual(txtLastname)
            {
                appDel?.profile.lastnameVer! = true
                appDel?.profile.lastname = sender.text
                self.txtLastname?.layer.borderWidth = 0
                vwError?.hidden = true
            }
        }else
        {
            
            if sender.isEqual(txtFirstname)
            {
                appDel?.profile.nameVer! = false
            }else if sender.isEqual(txtLastname)
            {
                appDel?.profile.lastnameVer! = false
            }
            
            if chk == "1"
            {
                var msg = ""
                if sender.isEqual(txtFirstname)
                {
                    msg = "First name is required"
                    self.txtFirstname?.layer.borderColor = UIColor.redColor().CGColor
                    self.txtFirstname?.layer.borderWidth = 1
                    
                }else if sender.isEqual(txtLastname)
                {
                    msg = "last name is required"
                    self.txtLastname?.layer.borderColor = UIColor.redColor().CGColor
                    self.txtLastname?.layer.borderWidth = 1
                }
                
                lblErrorMsg!.FAIcon = FAType.FAGithub
                lblErrorMsg!.setFAIcon(FAType.FAGithub, iconSize: 17)
                lblErrorMsg!.setFAText(prefixText: "", icon: FAType.FAClose, postfixText: msg, size: 12)
                vwError!.hidden = false
                
            }else if chk == "2"
            {
                if sender.isEqual(txtFirstname)
                {
                    defer{
                        dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                            
                            let alert = UIAlertController(title: "Name", message:"your message", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                                
                                
                                self.txtFirstname?.layer.borderColor = UIColor.redColor().CGColor
                                self.txtFirstname?.layer.borderWidth = 1
                                })
                            alert.message = "Please enter firstname with less than 20 alphabetical charcters"
                            self.presentViewController(alert, animated: true){}
                        })}
                }else if sender.isEqual(txtLastname)
                {
                    defer{
                        dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                            
                            let alert = UIAlertController(title: "Name", message:"your message", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                                
                                
                                self.txtLastname?.layer.borderColor = UIColor.redColor().CGColor
                                self.txtLastname?.layer.borderWidth = 1
                                })
                            alert.message = "Please enter lastname with less than 20 alphabetical charcters"
                            self.presentViewController(alert, animated: true){}
                        })}
                }
                
                
            }else if chk == "3"
            {
                
                if sender.isEqual(txtFirstname)
                {
                    defer{
                        dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                            
                            let alert = UIAlertController(title: "Name", message:"PLease enter only alphabetical letters in the lastname field", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                                
                                
                                self.txtFirstname?.layer.borderColor = UIColor.redColor().CGColor
                                self.txtFirstname?.layer.borderWidth = 1
                                })
                            
                            self.presentViewController(alert, animated: true){}
                        })}
                }else if sender.isEqual(txtLastname)
                {
                    defer{
                        dispatch_after(0, dispatch_get_main_queue(), { () -> Void in
                            
                            let alert = UIAlertController(title: "Name", message:"PLease enter only alphabetical letters in the firstname field", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                                
                                self.txtLastname?.layer.borderColor = UIColor.redColor().CGColor
                                self.txtLastname?.layer.borderWidth = 1
                                })
                           
                            self.presentViewController(alert, animated: true){}
                        })}
                }
                
            }
            
        }
        
        
        
        
    }
    @IBAction func verEmail(sender: UITextField) {
        
        activeField = sender
        
        if sender.text == ""
        {
            appDel?.profile.emailVer! = false
            lblErrorMsg!.FAIcon = FAType.FAGithub
            lblErrorMsg!.setFAIcon(FAType.FAGithub, iconSize: 17)
            lblErrorMsg!.setFAText(prefixText: "", icon: FAType.FARemove, postfixText: "\tEmail address is required", size: 12)
            vwError!.hidden = false
            self.txtEmail?.layer.borderColor = UIColor.redColor().CGColor
            self.txtEmail?.layer.borderWidth = 1
            
        }else
        {
            vwError?.hidden = true
            let x = validateEmail(sender.text!)
            
            if x == false
            {
                defer {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Email", message:"The email address you have entered is invalid. please enter a valid email address.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                            
                            self.txtEmail?.layer.borderColor = UIColor.redColor().CGColor
                            self.txtEmail?.layer.borderWidth = 1
                            
                            })
                        self.presentViewController(alert, animated: true){}
                    }) 
                }
            }else
            {
                self.txtEmail?.layer.borderWidth = 0
                appDel?.profile.email = sender.text
            }
        }
        
        
    }
    
    @IBAction func emailMatch(sender: AnyObject) {
        
        if txtEmail!.text != txtConfirmEmail!.text
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Email", message:"Email address do not match.Please enter the email addresses again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                        
                        self.txtConfirmEmail?.layer.borderColor = UIColor.redColor().CGColor
                        self.txtConfirmEmail?.layer.borderWidth = 1
                        
                        })
                    self.presentViewController(alert, animated: true){}
                })
            }
        }else
        {
            appDel?.profile.emailMatch! = true
            
            self.txtConfirmEmail?.layer.borderWidth = 0
            
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
        
       
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if appDel?.profile.nameVer! == true && appDel?.profile.lastnameVer! == true && appDel?.profile.email != "" && appDel?.profile.emailMatch! == true && appDel?.profile.day! != "" && appDel?.profile.month! != "" && appDel?.profile.year! != ""
        {
            
            let url = appDel?.services.validateEmail()
            let json : [String: AnyObject] = [ "email"  : (appDel?.profile.email)!]
            let request = HttpRequest().getRequest(url!, body: json,method: "POST")
            let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("popover")
            
            self.providesPresentationContextTransitionStyle = true;
            self.definesPresentationContext = true;
            self.presentViewController(popoverVC!, animated: false, completion: nil)
            
            defer{
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                
                dispatch_async(dispatch_get_main_queue(), {
                
                    popoverVC?.dismissViewControllerAnimated(false, completion: {
                        
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
                                dispatch_async( dispatch_get_main_queue(),{
                                    
                                    let alert = UIAlertController(title: "Error!!", message: "We couldnot continue with your request,please try again or contact help centre", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { _ in
                                        
                                        self.view.userInteractionEnabled = true
                                        
                                        })
                                    
                                    UIViewController.topMostController().presentViewController(alert, animated: true, completion: nil)
                                    
                                    
                                })
                                
                            }else if code == 404
                            {
                                
                                print("not found")
                                
                                dispatch_async( dispatch_get_main_queue(),{
                                    
                                    let alert = UIAlertController(title: "Error!!", message: "either the email doesnot exist,please verify", preferredStyle: UIAlertControllerStyle.Alert)
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
                                dispatch_async( dispatch_get_main_queue(),{
                                    
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
            }
            
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
                dispatch_async(dispatch_get_main_queue(),{
                    
                    let alert = UIAlertController(title: "DATE!!", message: "You did not select day", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                        
                        self.vwDY?.layer.borderColor = UIColor.redColor().CGColor
                        self.checkPic = "day"
                        
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
                
            }else if appDel?.profile.month! == ""
            {
                dispatch_async( dispatch_get_main_queue(),{
                    
                    let alert = UIAlertController(title: "DATE!!", message: "You did not select month", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                        
                        self.vwMonth?.layer.borderColor = UIColor.redColor().CGColor
                        self.checkPic = "month"
                        
                        
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
            }else if appDel?.profile.year! == ""
            {
                dispatch_async(dispatch_get_main_queue(),{
                    
                    let alert = UIAlertController(title: "DATE!!", message: "You did not select year", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in
                        
                        self.vwYear?.layer.borderColor = UIColor.redColor().CGColor
                        self.checkPic = "year"
                        
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
                
                
            }
        
        }
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
        
        if checkPic == "day"
        {
            return days.count
            
        }else if checkPic == "month"
        {
            return months.count
            
            
        }else if checkPic == "year"
        {
            return years.count
        }else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        
        if checkPic == "day"
        {
            return days[row]
            
        }else if checkPic == "month"
        {
            return months[row]
            
            
        }else if checkPic == "year"
        {
            return years[row]
        }else{
            return ""
        }
    }
        
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        if checkPic == "day"
        {
              lblDay!.text = days[row]
              appDel?.profile.day! = lblDay!.text!
            appDel?.profile.day = appDel?.profile.day!
            
        }else if checkPic == "month"
        {
            lblMonth!.text = months[row]
            appDel?.profile.month! = lblMonth!.text!
            
            
        }else if checkPic == "year"
        {
            lblYear!.text = years[row]
            appDel?.profile.year! = lblYear!.text!
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
    
}

