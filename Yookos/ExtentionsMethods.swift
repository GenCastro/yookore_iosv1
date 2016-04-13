//
//  ExtentionsMethods.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/08.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation
import ContactsUI

class Methods {
    
    init()
    {}
    
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
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    func getAllContacts() {
        
        let status = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) as CNAuthorizationStatus
        let arrContacts = NSMutableArray()
        if status == CNAuthorizationStatus.Denied {
            
            let alert = UIAlertController(title:nil, message:"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts", preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler:nil))
            UIViewController.topMostController().presentViewController(alert, animated:true, completion:nil)
            return
        }
        
        let store = CNContactStore()
        store.requestAccessForEntityType(CNEntityType.Contacts) { (granted:Bool, error:NSError?) -> Void in
            
            if !granted {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // user didn't grant access;
                    // so, again, tell user here why app needs permissions in order  to do it's job;
                    // this is dispatched to the main queue because this request could be running on background thread
                })
                return
            }
            
             // Declare this array globally, so you can access it in whole class.
            
            let request = CNContactFetchRequest(keysToFetch:[CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName)])
            
            do {
                
                try store.enumerateContactsWithFetchRequest(request, usingBlock: { (contact:CNContact, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    let arrEmail = contact.emailAddresses as NSArray
                    
                    if arrEmail.count > 0 {
                        
                        let dict = NSMutableDictionary()
                        dict.setValue((contact.givenName+" "+contact.familyName), forKey: "name")
                        let emails = NSMutableArray()
                        
                        for x in 0  ..< arrEmail.count  {
                            
                            let email:CNLabeledValue = arrEmail.objectAtIndex(x) as! CNLabeledValue
                            emails .addObject(email.value as! String)
                        }
                        dict.setValue(emails, forKey: "email")
                        arrContacts.addObject(dict) // Either retrieve only those contact who have email and store only name and email
                    }
                    //arrContacts.addObject(contact) // either store all contact with all detail and simplifies later on
                    for index in 0 ..< arrContacts.count {
                        
                        let dict = arrContacts[index] as! NSDictionary
                        print(dict.valueForKey("name"))
                        print(dict.valueForKey("email"))
                    }
                })
            } catch {
                
                return
            }
        }
        return

    }
    
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
class InsetLabel: UILabel {
    
    let topInset = CGFloat(10.0), bottomInset = CGFloat(10.0), leftInset = CGFloat(10.0), rightInset = CGFloat(10.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
class Color {

    
    init
    () {
    }
    
    func pickerBarColor() -> UIColor
    {
        return UIColor(netHex: 0xDCDCDC)
    }
    
    func titleBarColor() -> UIColor
    {
        return UIColor(netHex: 0x03A9F4)
    }
    
    func viewBorderColor() -> CGColor
    {
        return UIColor.blackColor().CGColor
    }
    func tokenColor() -> UIColor
    {
        return UIColor.groupTableViewBackgroundColor()
    }
    func fbColor() -> UIColor
    {
            return UIColor(netHex: 0x03A9F4)
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


extension UIViewController{
    
    class func topMostController() -> UIViewController {
        
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while(((topController?.presentedViewController)) != nil)
        {
            topController = topController?.presentedViewController
        }
        
        return topController!
    }
}


extension NSLayoutConstraint
{
    convenience init(item view1: AnyObject!,
    attribute attr1: NSLayoutAttribute,
    relatedBy relation: NSLayoutRelation,
    toItem view2: AnyObject!,
    attribute attr2: NSLayoutAttribute,
    multiplier: CGFloat,
    constant c: CGFloat)
    {
        self.init()
    }
    
    
}