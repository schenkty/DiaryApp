//
//  EntryListCell.swift
//  DiaryApp
//
//  Created by Ty Schenk on 9/5/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

class EntryListCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userMood: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var itemContentPreview: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = 10
        userImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
