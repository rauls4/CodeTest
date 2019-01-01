//
//  EntryTableViewCell.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/26/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit
import CoreData

protocol EntryTableViewCellDelegate:class {
    func didDeleteItem()
}

class EntryTableViewCell: UITableViewCell {

    weak var delegate:EntryTableViewCellDelegate?
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var entity:NSManagedObject?
    var contact:Contact?
    var cellType:CellTypes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    @IBAction func deleteEntry(_ sender: UIButton) {
        if let entity = entity, let cellType = cellType{
            switch cellType {
            case CellTypes.address:
                contact?.removeFromAddresses(entity as! Address)
                self.delegate?.didDeleteItem()
                self.removeFromSuperview()
            case CellTypes.email:
                contact?.removeFromEmails(entity as! Email)
                self.delegate?.didDeleteItem()
                self.removeFromSuperview()
            case CellTypes.phone:
                contact?.removeFromPhones(entity as! Phone)
                self.delegate?.didDeleteItem()
                self.removeFromSuperview()
           default:
                break
            }
        }else{
            debugPrint("Entity not found")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
