//
//  DobEntryTableViewCell.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/31/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

protocol DobEntryTableViewCellDelegate:class {
    func didChangeDateTo(date:Date)
}

class DobEntryTableViewCell: UITableViewCell {
    
    static let identifier = "dob"
    
    weak var delegate:DobEntryTableViewCellDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func datePicked(_ sender: Any) {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        self.delegate?.didChangeDateTo(date: datePicker.date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
