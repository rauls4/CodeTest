//
//  RecordDetailViewController.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/18/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

enum CellTypes{
    case fullName
    case firstName
    case secondName
    case dob
    case phone
    case email
    case address
}

class RecordDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var contact:Contact? //Our contact of interes
    var cellMap = [CellTypes]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    
    private func mapCells(){
        cellMap = [.fullName,.dob] //Minimum amount of fields on record

        if let contact = contact {
            if let addresses = contact.addresses {
                for _ in addresses{
                    cellMap.append(.address)
                }
            }
            if let emails = contact.emails {
                for _ in emails{
                    cellMap.append(.email)
                }
            }else{
                cellMap.append(.email)
            }
            if let phones = contact.phones {
                for _ in phones{
                    cellMap.append(.phone)
                }
            }else{
                cellMap.append(.phone)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit"{
            let recordViewTarget = segue.destination as! EditEntryViewController
            recordViewTarget.contact = contact
        }
    }
}

extension RecordDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "📇 Name"
        }
        if section == 1 {
            return "📅 Birthday"
        }
        if section == 2, let count = contact?.addresses?.count, count > 0 {
            if count > 1 {
            return "🏠 Addresses"
            }else{
              return "🏠 Address"
            }
        }
        if section == 3, let count = contact?.emails?.count, count > 0 {
            if  count > 1{
                return "✉ Emails"
            }else{
                 return "✉ Email"
            }
        }
        
        if section == 4, let count = contact?.phones?.count, count > 0 {
            if count > 1 {
                return "📞 Phones"
            }else{
                return "📞 Phone"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        if section == 2 {
            return(contact?.addresses?.count ?? 0)
        }
        if section == 3 {
            return(contact?.emails?.count ?? 0)
        }

        if section == 4 {
            return(contact?.phones?.count ?? 0)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "fullName", for: indexPath) as! FullNameDisplayTableViewCell
            cell.fullNameField.text = "\(contact?.firstName?.capitalized ?? "") \(contact?.secondName?.capitalized ?? "")"
            cell.contact = contact
            
            if contact?.favorite ?? false {
                cell.favButton.setTitle("♥", for: .normal)
            }else{
                cell.favButton.setTitle("♡", for: .normal)
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dob", for: indexPath) as! DobDysplayTableViewCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "MMM dd, yyyy"
            
            if let date = contact?.dob {
                let time = timeFormatter.string(from: date)
                 cell.dobField.text = time
            }
          
            
            
            
                    return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addresses", for: indexPath) as! AddressDisplayTableViewCell
            let addressObject = contact?.addresses?.object(at: indexPath.row) as! Address
            cell.textLabel?.text = addressObject.addressEntry
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emails", for: indexPath) as! EmailDisplayTableViewCell
            let emailObject = contact?.emails?.object(at: indexPath.row) as! Email
            cell.textLabel?.text = emailObject.emailAddress
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "phones", for: indexPath) as! PhoneDisplayTableViewCell
            let phoneObject = contact?.phones?.object(at: indexPath.row) as! Phone
            cell.textLabel?.text = phoneObject.phonenumber
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "phones", for: indexPath) as! PhoneDisplayTableViewCell
//            let phoneObject = contact?.phones?.object(at: indexPath.row) as! Phone
//             cell.textLabel?.text = phoneObject.phonenumber
//            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}
