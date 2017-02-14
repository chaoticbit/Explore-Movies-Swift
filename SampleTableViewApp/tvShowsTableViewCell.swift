//
//  tvShowsTableViewCell.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/14/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class tvShowsTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
