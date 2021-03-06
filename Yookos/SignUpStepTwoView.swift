//
//  SignUpStepOneView.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/02/25.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit
import CoreTelephony

class SignUpStepTwoView : UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate
{
    var appDel:AppDelegate?
    
    @IBOutlet var imgStep2: UIImageView!
    
    @IBOutlet var txtNumber: UITextField!
    @IBOutlet var txtConfirmNum: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPass: UITextField!
    
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblNum: UILabel!
    @IBOutlet var lblCountCode: UILabel!
    @IBOutlet var lblCountrySelect: UILabel!
    @IBOutlet var lblCountryDrop: UILabel!
    @IBOutlet var lblConfirmNum: UILabel!
    @IBOutlet var lblConfirmCode: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblConfirmPass: UILabel!
    @IBOutlet var lblCheckTnC: UILabel!
    @IBOutlet var lblAgree: UILabel!
    
    @IBOutlet var btnTnCs: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnHaveProb: UIButton!
    
    @IBOutlet var vwMainView: UIView!
    @IBOutlet var vwCountry: UIView!
    @IBOutlet var vwContent: UIView!
    
    @IBOutlet var scroller:UIScrollView?
    
    
    var pickOption :[String] = []
    var prefixCodes = NSMutableDictionary()
    var txtSelectCountry :UITextField = UITextField()
    
    var pickerView:UIPickerView!
    @IBOutlet var activeField: UITextField!
    
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFontOfSize(13.0),
        NSForegroundColorAttributeName : UIColor.blueColor(),
        NSUnderlineStyleAttributeName : 1]
    var attributedString = NSMutableAttributedString(string:"")
    
    var accepted = false
    var verPassword = false
    var passMatch = false
    var phoneMatch = false
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        
        //ADDING TAB GESTURE TO ALL VIEWS
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpStepTwoView.acceptTnCsTap(_:)))
        lblCheckTnC.addGestureRecognizer(tap)
        tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
        
        
        // ADD A TOOLBAR WITH A DONE BUTTON
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.barTintColor = Color.init().pickerBarColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignUpStepTwoView.donePicking(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: true)
        toolBar.userInteractionEnabled = true
        
        //CREATE A PICKER AND ASSIGN IT AS INPUT OF A TEXTFIELD
        
        let x = view.bounds.height * 0.666666667
        
        pickerView = UIPickerView(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: x))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.sizeToFit()
        
        txtSelectCountry.addTarget(self, action: #selector(SignUpStepTwoView.dateInput(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        txtSelectCountry.inputView = pickerView
        txtSelectCountry.inputAccessoryView = toolBar
        
        vwContent.addSubview(txtSelectCountry)
        
        
        //APPLYING FONT-AWESOME TO ALL COMPONANTS THAT USE SPECIAL FONTTS
        lblCountryDrop.FAIcon = FAType.FAGithub
        lblCountryDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblCountryDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblCheckTnC.FAIcon = FAType.FAGithub
        lblCheckTnC.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblCheckTnC.setFAText(prefixText: "", icon: FAType.FASquareO, postfixText: "", size: 22)
        
        //ADDING BORDERS TO THE DATE VIEWS
        lblCountCode.layer.borderColor = Color.init().viewBorderColor()
        lblCountCode.layer.borderWidth = 1.0
        lblConfirmCode.layer.borderColor = Color.init().viewBorderColor()
        lblConfirmCode.layer.borderWidth = 1.0
        
        txtNumber.layer.borderColor = Color.init().viewBorderColor()
        txtNumber.layer.borderWidth = 1.0
        txtConfirmNum.layer.borderColor = Color.init().viewBorderColor()
        txtConfirmNum.layer.borderWidth = 1.0

        let buttonTitleStr = NSMutableAttributedString(string:"having a problem with signing up?", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        btnHaveProb.setAttributedTitle(attributedString, forState: .Normal)
        
        let body: NSDictionary? = NSDictionary()
        let url = appDel?.services.countriesUrl()
        let request = HttpRequest().getRequest(url!, body: body!, method: "GET")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    
                    if let httpResponse = response as? NSHTTPURLResponse {
                        
                        let code = httpResponse.statusCode
                        print(code)
                        
                        if code == 200
                        {
                            do{
                                let countries = try NSJSONSerialization.JSONObjectWithData((data! as NSData!), options: []) as! NSMutableArray
                                
                                for i in 0 ..< countries.count
                                {
                                    let country = countries[i] as! NSMutableDictionary
                                    let countName = country.valueForKey("name") as! String
                                    self.pickOption.append(countName)
                                   
                                    self.prefixCodes.setValue(country.valueForKey("dialCode") as! String, forKey: countName)
                                    
                                }
                                
                                
                                let curCountry = NSUserDefaults.standardUserDefaults().objectForKey("country") as? String
                                
                                if(curCountry != nil)
                                {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.lblCountrySelect.text = NSUserDefaults.standardUserDefaults().objectForKey("country") as? String
                                        self.lblCountCode.text = self.prefixCodes.valueForKey(curCountry!) as? String
                                        self.lblConfirmCode.text = self.prefixCodes.valueForKey(curCountry!) as? String
                                        
                                        
                                    })
                                    
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                
                                    let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpStepTwoView.countryTap(_:)))
                                    self.vwCountry.addGestureRecognizer(tap)
                                })
                            }catch{
                                
                            }
                            
                        }else
                        {
                            
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
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        scroller!.contentSize = CGSizeMake(view.bounds.width,700)
        
        
    }
    
    /*############################################################################################
    
    ------>  ---->  WHEN VIEWS ARE TAPPED
    
    ###########################################################################################*/
    
    func countryTap(sender: UITapGestureRecognizer? = nil) {
        
        
        let curCountry = NSUserDefaults.standardUserDefaults().objectForKey("country") as? String
        
        if(curCountry != nil)
        {
            dispatch_async(dispatch_get_main_queue(), {
               
                
                self.pickerView.selectRow(self.pickOption.indexOf(curCountry!)!, inComponent: 0, animated: true)
                self.txtSelectCountry.becomeFirstResponder()
                self.lblCountrySelect.text = curCountry
                self.lblCountCode.text =  self.prefixCodes.valueForKey(curCountry!) as? String
                self.lblConfirmCode.text = self.prefixCodes.valueForKey(curCountry!) as? String
                
                
            })
            
        }
        
        
        
    }
    
    func acceptTnCsTap(gr:UITapGestureRecognizer)
    {
        
        if accepted == false
        {
            lblCheckTnC.FAIcon = FAType.FAGithub
            lblCheckTnC.setFAIcon(FAType.FAGithub, iconSize: 17)
            lblCheckTnC.setFAText(prefixText: "", icon: FAType.FACheckSquare, postfixText: "", size: 22)
            accepted = true
        }else
        {
            lblCheckTnC.FAIcon = FAType.FAGithub
            lblCheckTnC.setFAIcon(FAType.FAGithub, iconSize: 17)
            lblCheckTnC.setFAText(prefixText: "", icon: FAType.FASquareO, postfixText: "", size: 22)
            accepted = false
        }
        
        print(" true = Checked // false = unchecked  ---> \(accepted)")
        
    }
    
    /*############################################################################################
    
    ------>  ---->  WHEN BUTTONS ARE CLICKED
    
    ###########################################################################################*/
    @IBAction func termsNconditions(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("tnc")
        UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
    }
    @IBAction func signup(sender: AnyObject) {
        
        
        if verPassword == false
        {
            validatePassword(txtPassword)
            return
        }
        
        if passMatch == false
        {
            matchPass(txtConfirmPass)
            return
            
        }
        
        if accepted == false
        {
            dispatch_async( dispatch_get_main_queue(),{
                let alert = UIAlertController(title: "ERROR", message:"You have to accept terms and conditions to register", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                UIViewController.topMostController().presentViewController(alert, animated: true){}
            })
            
            return
        }
        
        

            appDel?.profile.currentcountry = lblCountrySelect.text!
            appDel?.profile.cellphone = lblCountCode.text! + txtNumber.text!
            appDel?.profile.password = txtPassword.text
            appDel?.profile.terms = accepted
            
            let url = appDel?.services.signUp()
        
        let json :[String : AnyObject]?

        if txtNumber.text != ""
        {
            if phoneMatch == false{
                
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "ERROR", message:"You have to accept terms and conditions to register", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
                
                return
            }
            
            
            json = ["password":(appDel?.profile.password)!,
                                              "firstname":(appDel?.profile.firstname)!,
                                              "lastname":(appDel?.profile.lastname)!,
                                              "cellphone":(appDel?.profile.cellphone)!,
                                              "email":(appDel?.profile.email)!,
                                              "currentcountry":(appDel?.profile.currentcountry)!,
                                              "birthdate":(appDel?.profile.birthdate)!,
                                              "gender":(appDel?.profile.gender)!,
                                              "terms":(appDel?.profile.terms)!]

            
        }else{
            
             json  = ["password":(appDel?.profile.password)!,
                                              "firstname":(appDel?.profile.firstname)!,
                                              "lastname":(appDel?.profile.lastname)!,
                                              "email":(appDel?.profile.email)!,
                                              "currentcountry":(appDel?.profile.currentcountry)!,
                                              "birthdate":(appDel?.profile.birthdate)!,
                                              "gender":(appDel?.profile.gender)!,
                                              "terms":(appDel?.profile.terms)!]

            
        }
        
            let request = appDel?.httpRequest.getRequest(url!, body: json!,method: "POST")
            
            let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("popover")
            
            self.providesPresentationContextTransitionStyle = true;
            self.definesPresentationContext = true;
            self.presentViewController(popoverVC!, animated: false, completion: nil)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request!){ data, response, error in
                
                dispatch_async(dispatch_get_main_queue(),{
                popoverVC?.dismissViewControllerAnimated(false, completion: {
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    let code = httpResponse.statusCode
                    print(code)
                    if code == 200
                    {
                     
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(self.appDel!.profile.email, forKey: "email")
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("versignup")
                            
                            dispatch_async(dispatch_get_main_queue(),{
                            
                                UIViewController.topMostController().presentViewController(nextViewController, animated:true, completion:nil)
                                
                            
                            })
                            
                        

                        
                        
                    }else if code == 409
                    {
                        if self.txtNumber.text != ""
                        {
                            defer {
                                dispatch_async( dispatch_get_main_queue(),{
                                    let alert = UIAlertController(title: "Error", message:"please make sure you have not used the email on Yokoos before,and also verify your number", preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                                })
                            }
                        }
                        else
                        {
                            defer {
                                dispatch_async( dispatch_get_main_queue(),{
                                    let alert = UIAlertController(title: "Error", message:"please make sure you have not used the email on Yokoos before", preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                                })
                            }
                        }
                        
                        
                    }else
                    {
                        defer {
                            dispatch_async( dispatch_get_main_queue(),{
                                let alert = UIAlertController(title: "ERROR", message:"We couldnt complete your request,please try again", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                                UIViewController.topMostController().presentViewController(alert, animated: true){}
                            })
                        }
                    }

                    
                }else
                {
                    
                }
                
                if error != nil{
                    
                    print(error)
                    return
                }
                })})
            }
            
            task.resume()
            
        
        
    }
    @IBAction func haveProblem(sender: AnyObject) {
        
        dispatch_after(1,dispatch_get_main_queue(), { () -> Void in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("help")
            
            let view = UIViewController.topMostController()
            view.presentViewController(nextViewController, animated:true, completion:nil)
            
        })
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
        
        
        let cntName = pickOption[row]
        lblCountrySelect.text = cntName
        lblCountCode.text = prefixCodes.valueForKey(cntName ) as? String
        lblConfirmCode.text =  prefixCodes.valueForKey(cntName ) as? String
        
        
    }
    func donePicking(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
    }
   

    
    /*############################################################################################
    
    ------>  ---->  WHEN TEXTFIELDS ARE ACTIVE
    
    ###########################################################################################*/
    @IBAction func dateInput(sender: UITextField) {
        
        activeField = sender
    }
    @IBAction func enterNumber(sender: AnyObject) {
       
        
        appDel?.profile.cellphone = txtNumber.text
        
    }
    
    @IBAction func matchNumbers(sender: AnyObject) {
        
        
        if txtNumber.text == txtConfirmNum.text {
            phoneMatch = true
        }
        
        
    }
    @IBAction func validatePassword(sender: UITextField) {
        
        let txt = sender.text
        
        if txt?.characters.count < 6
        {
            verPassword = false
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Password", message:"Please enter password with at least one capital letter, a number and a minimum of six characters", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
        }else
        {
            let result = checkTextSufficientComplexity(txt!)
            verPassword = result
            if result == false
            {
                defer {
                    dispatch_async( dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Password", message:"Please enter password with at least one capital letter, a number and a minimum of six characters", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                        UIViewController.topMostController().presentViewController(alert, animated: true){}
                    })
                }
            }
        }
       

    }
    @IBAction func matchPass(sender: AnyObject) {
        
         passMatch = true
        
        if txtConfirmPass.text == ""
        {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Password", message:"password entered dont match", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }

        }
        else if txtConfirmPass.text != txtPassword.text
        {
            passMatch = false
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Password", message:"The passwords entered do not match.Please enter password again", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    UIViewController.topMostController().presentViewController(alert, animated: true){}
                })
            }
        }
    }
    func checkTextSufficientComplexity( text : String) -> Bool{
        
        
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let txtCapCase = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = txtCapCase.evaluateWithObject(text)
        print("\(capitalresult)")
        
         let clowLetterRegEx = ".*[a-z]+.*"
        let lowCaseTxt = NSPredicate(format:"SELF MATCHES %@", clowLetterRegEx)
        let lowCase = lowCaseTxt.evaluateWithObject(text)
        print("\(lowCase)")
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluateWithObject(text)
        print("\(numberresult)")
        
        if capitalresult == true && numberresult == true && lowCase == true
        {
            return true
        }
        
        return false
    }
    
}


