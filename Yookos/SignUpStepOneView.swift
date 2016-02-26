//
//  SignUpStepOneView.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/02/25.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class SignUpStepOneView : UIViewController
{
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
    
    @IBOutlet var vwDY: UIView!
    @IBOutlet var vwMonth: UIView!
    @IBOutlet var vwYear: UIView!
    @IBOutlet var theView: UIView!
    
    
    @IBOutlet var scroller:UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scroller = UIScrollView(frame: view.bounds)
//        scroller!.contentSize = view.bounds.size
//        scroller!.contentSize.height = view.bounds.height
//        scroller!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//        
//        
//        view.addSubview(scroller!)
//        scroller!.addSubview(imgStep1)
//        
//        scroller!.addSubview(txtFirstname)
//        scroller!.addSubview(txtLastname)
//        scroller!.addSubview(txtEmail)
//        scroller!.addSubview(txtConfirmEmail)
//        
//        scroller!.addSubview(lblEmail)
//        scroller!.addSubview(lblFirstname)
//        scroller!.addSubview(lblConfirmEmail)
//        scroller!.addSubview(lblGender)
//        scroller!.addSubview(lblLastname)
//        scroller!.addSubview(lblDate)
//        scroller!.addSubview(lblMaleGen)
//        
//        scroller!.addSubview(vwDY)
//        scroller!.addSubview(vwYear)
//        scroller!.addSubview(vwMonth)
        
        
        
//
//        lblMaleGen.FAIcon = FAType.FAGithub
//        
//        lblMaleGen.setFAIcon(FAType.FAGithub, iconSize: 10)
//        
//        lblMaleGen.setFAText(prefixText: "follow me on ", icon: FAType.FATwitter, postfixText: ". Thanks!", size: 10)
//        
//         //bigger icon:
//        //lblMaleGen.setFAText(prefixText: "follow me on  ", icon: FAType.FATwitter, postfixText: ".Thanks!", size: 25, iconSize: 30)
//        
//        
//        lblMaleGen.textColor = UIColor.blueColor()
        
        
//        scroller = UIScrollView.init()
//        
//        self.view.addSubview(scroller)
//        scroller
//        
//        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
//        imageView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scrollView,imageView);
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 viewsDictionary:viewsDictionary]];
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 viewsDictionary:viewsDictionary]];
//        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics: 0 viewsDictionary:viewsDictionary]];
//        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics: 0 viewsDictionary:viewsDictionary]];

    }
    
//    override func viewDidAppear(animated: Bool)
//    {
//        super.viewDidAppear(animated)
//        scroller!.contentSize = CGSizeMake(view.bounds.width,1300)
//    
//    }
    
}
