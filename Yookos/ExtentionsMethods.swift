//
//  ExtentionsMethods.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/08.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


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
        return UIColor(netHex: 0x00BFFF)
    }
    
    func viewBorderColor() -> UIColor
    {
        return UIColor(netHex: 0x03A9F4)
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