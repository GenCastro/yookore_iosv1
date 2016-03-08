//
//  TermsNConditions.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/07.
//  Copyright © 2016 yookos. All rights reserved.
//

import Foundation


class TermsNConditions: UIViewController {
    
    
    
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL (string: "http://google.com")
        //let url = NSURL (string: "https://chat.yookos.com/files/assests/terms.html")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func done(sender: AnyObject) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}