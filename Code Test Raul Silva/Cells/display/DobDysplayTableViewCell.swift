//
//  DobDysplayTableViewCell.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/20/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

class DobDysplayTableViewCell: UITableViewCell {

    static let identifer = "dob"

    @IBOutlet weak var dobField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
