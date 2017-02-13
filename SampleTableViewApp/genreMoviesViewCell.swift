//
//  genreDetailViewCell.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/12/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class genreMoviesViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var summary: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
