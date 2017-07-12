//
//  TagTableViewCell.swift
//  MeetingTag
//
//  Created by Jerry XU on 11/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var tagLabel: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
