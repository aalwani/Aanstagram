//
//  commentCell.swift
//  Aanstagram
//
//  Created by Aanya Alwani on 6/23/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var namei: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
