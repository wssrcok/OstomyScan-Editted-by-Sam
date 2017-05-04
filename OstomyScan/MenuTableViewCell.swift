//
//  MenuTableViewCell.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/24/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
