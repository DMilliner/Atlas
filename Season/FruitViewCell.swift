//
//  FruitViewCell.swift
//  Season
//
//  Created by David Milliner on 11/18/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class FruitViewCell: UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var FruitCellLabel: UILabel!
    @IBOutlet weak var FruitCellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialize the code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for selected state
    }
}
