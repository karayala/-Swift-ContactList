//
//  ContactTableViewCell.swift
//  ContactList
//
//  Created by Kartik Ayala on 3/3/16.
//  Copyright © 2016 Kartik Ayala. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {


    @IBOutlet var imageBox: UIImageView!
    
    @IBOutlet var nameBox: UILabel!
    
    @IBOutlet var phoneBox: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageBox.contentMode = .ScaleAspectFit
        self.imageBox.layer.cornerRadius = self.imageBox.frame.size.width / 2
        self.imageBox.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
