//
//  MainTableViewCell.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
