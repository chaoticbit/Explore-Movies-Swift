//
//  customTableViewCell.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/9/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nationality: UILabel!
    @IBOutlet weak var posterImage: UIImageView!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
