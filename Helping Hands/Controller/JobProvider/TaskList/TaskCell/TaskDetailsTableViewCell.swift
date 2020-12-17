//
//  TaskDetailsTableViewCell.swift
//  iOS
//
//  Created by iOS on 11/04/2020.
//  Copyright © 2020 iOS Technology All rights reserved.
//

import UIKit

class TaskDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
