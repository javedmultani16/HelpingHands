//
//  TaskTableViewCell.swift
//  iOS
//
//  Created by iOS on 12/05/2020.
//  Copyright © 2020 iOS Technology . All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rmLabel: UILabel!
    @IBOutlet weak var hieghtConstrain: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var perhrLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var catLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2.0
        profilePic.clipsToBounds = true
        
//         mainView.layer.cornerRadius = 8.0
//                           mainView.clipsToBounds = true
                    
                    mainView.layer.shadowColor = UIColor.black.cgColor
                    mainView.layer.shadowOffset = CGSize(width: 0.0, height: 0)
                    mainView.layer.shadowRadius = 4.0
                    mainView.layer.shadowOpacity = 0.25
                   mainView.layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
