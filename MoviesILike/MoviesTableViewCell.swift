//
//  MoviesTableViewCell.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    // Object references to the table view cell UI objects instantiated in the Storyboard
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var audienceScoreLabel: UILabel!
    @IBOutlet var movieStarsLabel: UILabel!
    @IBOutlet var mpaaRatingRuntimeDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
