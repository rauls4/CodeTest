//
//  ContactTableViewCell.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/18/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier = "recordCell"
    
    var contact:Contact?
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var adressCount: UILabel!
    @IBOutlet weak var phonesCount: UILabel!
    @IBOutlet weak var emailsCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleLabels(labels: [adressCount,phonesCount,emailsCount])
    }
    
    private func styleLabels(labels:[UILabel]){
        for label in labels {
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        }
    }
    
    @IBAction func toggleFav(_ sender: UIButton) {
        if let state = contact?.favorite{
            contact?.favorite = !state
            if !state {
                favButton.setTitle("♥", for: .normal)
            }else{
                favButton.setTitle("♡", for: .normal)
            }
        }
         DataManager.saveRecords()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
