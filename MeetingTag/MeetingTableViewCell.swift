//
//  MeetingTableViewCell.swift
//  MeetingTag
//
//  Created by Jerry XU on 10/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import UIKit

class MeetingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
