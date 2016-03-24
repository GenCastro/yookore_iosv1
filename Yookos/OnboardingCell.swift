//
//  OnboardingLocationCellTableViewCell.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/09.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class OnboardingCell: UITableViewCell {

    @IBOutlet var lblCurCountry: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblHomeCountry: UILabel!
    @IBOutlet var lblHomeCity: UILabel!
    @IBOutlet var txtCurCity: UITextField!
    
    @IBOutlet var lblSkulType: UILabel!
    @IBOutlet var lblYearTo: UILabel!
    @IBOutlet var lblYearFrom: UILabel!
    @IBOutlet var txtSkulName: UITextField!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
