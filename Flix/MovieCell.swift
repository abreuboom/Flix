//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Alvin Magee on 6/21/17.
//  Copyright © 2017 Alvin Magee. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
