//
//  ProfilePostCell.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/21/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfilePostCell: UITableViewCell {
    
    @IBOutlet weak var posterView: PFImageView!
    
  //  @IBOutlet weak var captionLabel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
