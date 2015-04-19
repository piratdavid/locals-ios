//
//  CustomCell.swift
//  Locals
//
//  Created by David Smallbone Tizard on 2015-04-17.
//  Copyright (c) 2015 David Smallbone Tizard. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setName(name: String) {
        self.nameLabel = UILabel();
        self.nameLabel.text = name;
    }

}
