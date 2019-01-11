//
//  EditEntryViewController.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/18/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit
import CoreData

class EditEntryViewController: UIViewController {
    
    static let editSegueIdentifier = "toEdit"
    static let newSegueIdentifier = "toNew"
    
    var contact:Contact?
    var isNew = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepTable()
        if isNew {
            self.title = "New contact"
            if let contact = contact{
                DataManager.addEmptyRecord(type: .email, contact: contact)
                DataManager.addEmptyRecord(type: .phone, contact: contact)
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashRecord(_:)))
    }
    
    private func prepTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 5
        tableView.clipsToBounds = true
    }
    
    @objc private func trashRecord(_ sender:UIBarButtonItem){
        let alert = UIAlertController(title: "Are you sure?", message: "You wan't to delete this record permanently?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { action in
            if let contact = self.contact,    DataManager.deleteRecord(record: contact) {
                self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        DataManager.saveRecords()
    }
    
    @objc private func addField(sender: UIButton?) {
        if let contact = contact{
            switch sender?.tag{
            case 4:
                if DataManager.addAttribute(value: "", toEntity: contact, targetEntityName: "Email", targetRelationship: "email", targetAttribute: "emailAddress"){
                    tableView.reloadData()
                }
            case 3:
                if DataManager.addAttribute(value: "", toEntity: contact, targetEntityName: "Address", targetRelationship: "address", targetAttribute: "addressEntry"){
                    tableView.reloadData()
                }
            case 5:
                if DataManager.addAttribute(value: "", toEntity: contact, targetEntityName: "Phone", targetRelationship: "phone", targetAttribute: "phonenumber"){
                    tableView.reloadData()
                }
            default:
                break
            }
        }
    }
}

extension EditEntryViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String?
        if section == 4 {title = "Emails"}
        if section == 3 {title = "Adresses"}
        if section == 5 {title = "Phones"}
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
            headerView.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            let label = UILabel()
            label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = title
            headerView.addSubview(label)
            let button = UIButton(frame: CGRect(x: headerView.frame.width - 50, y: 0, width: 50, height: 30))
            button.setTitle("+", for: .normal)
            button.tag = section
            button.addTarget(self,action:#selector(addField),for:.touchUpInside)
            button.setTitleColor(self.view.tintColor, for: .normal)
            headerView.addSubview(button)
            return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 2 {
            return 30
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsTotal = 0
        if section == 4 {
            if contact?.emails?.count ?? 1 > 0{
                rowsTotal += contact?.emails?.count ?? 0
            }
        }
        if section == 3 {
            if contact?.addresses?.count ?? 1 > 0 {
                rowsTotal += contact?.addresses?.count ?? 0
            }
        }
        if section == 5 {
            if contact?.phones?.count ?? 1 > 0 {
                rowsTotal += contact?.phones?.count ?? 0
            }
        }
        if section < 3{
            rowsTotal += 1
        }
        return rowsTotal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
            cell.entryField.text = contact?.firstName?.capitalized ?? ""
            cell.delegate = self
            cell.contact = contact
            cell.cellType = .firstName
            cell.cellTitle.text = "First Name:"
            cell.deleteButtonWidthContraint.constant = 0
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
            cell.entryField.text = contact?.secondName?.capitalized ?? ""
            cell.delegate = self
            cell.contact = contact
            cell.cellType = .secondName
            cell.cellTitle.text = "Last Name:"
            cell.deleteButtonWidthContraint.constant = 0
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DobEntryTableViewCell.identifier, for: indexPath) as! DobEntryTableViewCell
            if let date = contact?.dob{
                cell.datePicker.date = date
            }
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
            if let count = contact?.addresses?.count, count > 0, indexPath.row < count {
                let addressObject = contact?.addresses?.object(at: indexPath.row) as! Address
                cell.entryField.text = addressObject.addressEntry
                cell.cellTitle.isHidden = true
                cell.entity = addressObject
                cell.delegate = self
                cell.contact = contact
                cell.cellType = .address
                cell.deleteButtonWidthContraint.constant = 30
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
            if let count = contact?.emails?.count, count > 0, indexPath.row < count {
                let emailObject = contact?.emails?.object(at: indexPath.row) as? Email
                cell.entryField.text = emailObject?.emailAddress
                 cell.cellTitle.isHidden = true
                cell.entity = emailObject
                cell.delegate = self
                cell.contact = contact
                cell.cellType = .email
                if count < 2 {
                    cell.deleteButtonWidthContraint.constant = 0
                }else{
                    cell.deleteButtonWidthContraint.constant = 30
                }
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
            if let count = contact?.phones?.count, count > 0 , indexPath.row < count{
                let phoneObject = contact?.phones?.object(at: indexPath.row) as! Phone
                cell.entryField.text = phoneObject.phonenumber
                 cell.cellTitle.isHidden = true
                cell.entity = phoneObject
                cell.contact = contact
                cell.cellType = .phone
                cell.delegate = self
                if count < 2 {
                    cell.deleteButtonWidthContraint.constant = 0
                }else{
                    cell.deleteButtonWidthContraint.constant = 30
                }
            }
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension EditEntryViewController:EntryTableViewCellDelegate{
    func didDeleteItem() {
        tableView.reloadData()
    }  
}

extension EditEntryViewController:DobEntryTableViewCellDelegate{
    func didChangeDateTo(date: Date) {
        contact?.dob = date
        DataManager.saveRecords()
    }
}
