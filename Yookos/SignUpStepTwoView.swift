//
//  SignUpStepOneView.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/02/25.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

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
    var pickCountryCode :[String] = []
    var txtDateInput :UITextField = UITextField()
    
    var pickerView:UIPickerView!
    @IBOutlet var activeField: UITextField!
    
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFontOfSize(13.0),
        NSForegroundColorAttributeName : UIColor.blueColor(),
        NSUnderlineStyleAttributeName : 1]
    var attributedString = NSMutableAttributedString(string:"")
    
    var accepted = false
    var countrySelected = false
    var verPassword = false
    var passMatch = false
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        scroller = UIScrollView(frame: view.bounds)
        scroller!.contentSize = view.bounds.size
        scroller!.contentSize.height = view.bounds.height
        scroller!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        vwMainView.addSubview(scroller!)
        scroller?.addSubview(vwContent)
        vwContent.addSubview(txtDateInput)
        //scroller?.addConstraint(NSLayoutConstraint(item: btnHaveProb, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: vwMainView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        
        
        //ADDING TAB GESTURE TO ALL VIEWS
        var tap = UITapGestureRecognizer(target: self, action: Selector("countryTap:"))
        vwCountry.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: Selector("acceptTnCsTap:"))
        lblCheckTnC.addGestureRecognizer(tap)
        tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
        
        
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
        
        let x = view.bounds.height * 0.666666667
        
        pickerView = UIPickerView(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: x))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.sizeToFit()
        
        txtDateInput.addTarget(self, action: "dateInput:", forControlEvents: UIControlEvents.EditingDidBegin)
        txtDateInput.inputView = pickerView
        txtDateInput.inputAccessoryView = toolBar
        
        
        //APPLYING FONT-AWESOME TO ALL COMPONANTS THAT USE SPECIAL FONTTS
        lblCountryDrop.FAIcon = FAType.FAGithub
        lblCountryDrop.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblCountryDrop.setFAText(prefixText: "", icon: FAType.FAAngleDown, postfixText: "", size: 25)
        
        lblCheckTnC.FAIcon = FAType.FAGithub
        lblCheckTnC.setFAIcon(FAType.FAGithub, iconSize: 17)
        lblCheckTnC.setFAText(prefixText: "", icon: FAType.FASquareO, postfixText: "", size: 22)
        
        //ADDING BORDERS TO THE DATE VIEWS
        lblCountCode.layer.borderColor = UIColor.lightGrayColor().CGColor
        lblCountCode.layer.borderWidth = 1.0
        lblConfirmCode.layer.borderColor = UIColor.lightGrayColor().CGColor
        lblConfirmCode.layer.borderWidth = 1.0
        
        txtNumber.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtNumber.layer.borderWidth = 1.0
        txtConfirmNum.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtConfirmNum.layer.borderWidth = 1.0

        let buttonTitleStr = NSMutableAttributedString(string:"having a problem with signing up?", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        btnHaveProb.setAttributedTitle(attributedString, forState: .Normal)

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
        
        pickOption = []
        pickCountryCode = []
        for locale in NSLocale.locales() {
            
            pickOption.append(locale.countryName)
            pickCountryCode.append(locale.countryCode)
        }
        
        pickerView.selectRow(pickCountryCode.indexOf("ZA")!, inComponent: 0, animated: true)
        txtDateInput.becomeFirstResponder()
        lblCountrySelect.text = pickOption[pickCountryCode.indexOf("ZA")!]
        lblCountCode.text = "+" + prefixCodes["ZA"]!
        lblConfirmCode.text = "+" + prefixCodes["ZA"]!
        countrySelected = true
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
    }
    @IBAction func signup(sender: AnyObject) {
        
        appDel?.profile.currentcountry = lblCountrySelect.text
        appDel?.profile.cellphone = lblCountCode.text! + txtNumber.text!
        appDel?.profile.password = txtPassword.text
        appDel?.profile.terms = accepted
        
        let url = appDel?.services.signUp()
        let json :[String : AnyObject] = ["password":(appDel?.profile.password)!,
                                          "firstname":(appDel?.profile.firstname)!,
                                          "lastname":(appDel?.profile.lastname)!,
                                          "cellphone":(appDel?.profile.cellphone)!,
                                          "email":(appDel?.profile.email)!,
                                          "currentcountry":(appDel?.profile.currentcountry)!,
                                          "birthdate":(appDel?.profile.birthdate)!,
                                          "gender":(appDel?.profile.gender)!,
                                          "terms":(appDel?.profile.terms)!]
        
        appDel?.httpRequest.makePostRequest(url!, body: json, objClass: "signup2", funcName: "signup")
        
    }
    @IBAction func haveProblem(sender: AnyObject) {
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
        
        lblCountrySelect.text = pickOption[row]
        
        
        lblCountCode.text = "+" + prefixCodes[pickCountryCode[row]]!
        lblConfirmCode.text = "+" + prefixCodes[pickCountryCode[row]]!
        
        
        
    }
    func donePicking(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
    }
    /*############################################################################################
    
    ------>  ---->  HTTP REQUEST
    
    ###########################################################################################*/
    func receiveRequest(code :Int,response :AnyObject,funcName : String)
    {
        if funcName == "signup"
        {
            if code == 200
            {
                print(response.valueForKey("username"))
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

    
    /*############################################################################################
    
    ------>  ---->  WHEN TEXTFIELDS ARE ACTIVE
    
    ###########################################################################################*/
    @IBAction func dateInput(sender: UITextField) {
        
        activeField = sender
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
                    self.presentViewController(alert, animated: true){}
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
                        self.presentViewController(alert, animated: true){}
                    })
                }
            }
        }
       

    }
    @IBAction func matchEmails(sender: AnyObject) {
        
         passMatch = true
        if txtConfirmPass.text != txtPassword.text
        {
            passMatch = false
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                    let alert = UIAlertController(title: "Password", message:"The passwords entered do not match.Please enter password again", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
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
    
    
    
    
    
    
    
    var prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263","AQ" : "672","AX" :"358","BV":"47","BQ":"599","CW": "599","TF": "68","SX": "1","SS": "211","EH":"212"]
}

extension NSLocale {
    
    struct Locale {
        let countryCode: String
        let countryName: String
    }
    
    class func locales() -> [Locale] {
        
        var locales = [Locale]()
        for localeCode in NSLocale.ISOCountryCodes() {
            let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: localeCode)!
            let countryCode = localeCode 
            let locale = Locale(countryCode: countryCode, countryName: countryName)
            locales.append(locale)
        }
        
        return locales
    }
    
}
