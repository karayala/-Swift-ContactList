//
//  TableViewCell.swift
//  ContactList
//
//  Created by Kartik Ayala on 3/3/16.
//  Copyright © 2016 Kartik Ayala. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var displayLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.displayLabel.contentMode = .ScaleAspectFit
        self.displayLabel.layer.cornerRadius = self.displayLabel.frame.size.width / 2
        self.displayLabel.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
