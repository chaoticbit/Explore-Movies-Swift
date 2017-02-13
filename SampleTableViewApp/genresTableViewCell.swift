//
//  genresTableViewCell.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/11/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class genresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
