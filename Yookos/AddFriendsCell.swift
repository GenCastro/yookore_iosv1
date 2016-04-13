//
//  AddFriendsCell.swift
//  Yookos
//
//  Created by Zwelithini Mathebula on 2016/03/31.
//  Copyright © 2016 yookos. All rights reserved.
//

import UIKit

class AddFriendsCell: UITableViewCell {

    @IBOutlet var btnInvite: UIButton!
    @IBOutlet var imgAvatar: UIImageView!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
