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
    @IBOutlet weak var deleteButtonWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var cellTitle: UILabel!
    
    var entity:NSManagedObject?
    var contact:Contact?
    var cellType:CellTypes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        entryField.delegate = self
        entryField.layer.borderWidth = 1.0
        entryField.layer.borderColor = UIColor.darkGray.cgColor
        
    }

    @IBAction func deleteEntry(_ sender: UIButton) {
        if let entity = entity, let cellType = cellType{
            switch cellType {
            case .address:
                contact?.removeFromAddresses(entity as! Address)
                self.delegate?.didDeleteItem()
                self.removeFromSuperview()
            case .email:
                contact?.removeFromEmails(entity as! Email)
                self.delegate?.didDeleteItem()
                self.removeFromSuperview()
            case .phone:
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
    
    
    private func editRecord(textField: UITextField){
        switch cellType {
        case CellTypes.firstName?:
            contact?.firstName = textField.text
        case CellTypes.secondName?:
            contact?.secondName = textField.text
        case CellTypes.email?:
            (entity as! Email).emailAddress = textField.text
        case CellTypes.address?:
            (entity as! Address).addressEntry = textField.text
        case CellTypes.phone?:
            (entity as! Phone).phonenumber = textField.text
        default:
            break
        }
        DataManager.saveRecords()
    }
}

extension EntryTableViewCell:UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.editRecord(textField: textField)
        }
}
