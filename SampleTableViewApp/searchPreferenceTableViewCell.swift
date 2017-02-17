//
//  searchPreferenceTableViewCell.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/17/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class searchPreferenceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchPreferenceLabel: UILabel!
    
    @IBOutlet weak var preferenceSelectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
