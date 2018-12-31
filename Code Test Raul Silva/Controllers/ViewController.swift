//
//  ViewController.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/18/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var contacts:[Contact]?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        contacts = DataManager.fetchRecords()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! ContactTableViewCell
    
        if let phones = contacts?[indexPath.row].phones{
                cell.phonesCount.text = String(phones.count)
        }
        
        if let addresses = contacts?[indexPath.row].addresses{
                cell.adressCount.text = String(addresses.count)
        }
        
        if let emails = contacts?[indexPath.row].emails{
                cell.emailsCount.text = String(emails.count)
        }
        
        if let firstName = contacts?[indexPath.row].firstName, let secondName = contacts?[indexPath.row].secondName {
            cell.mainLabel.text = firstName.capitalized + " " + secondName.capitalized
            cell.contact = contacts?[indexPath.row]
            if contacts?[indexPath.row].favorite ?? false{
                cell.favButton.setTitle("♥", for: .normal)
            }else{
                cell.favButton.setTitle("♡", for: .normal)
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecord"{
            let cellIndex =  self.tableView.indexPath(for: sender as! UITableViewCell)
            let recordViewTarget = segue.destination as! RecordDetailViewController
            if let row = cellIndex?.row {
                recordViewTarget.contact = contacts?[row]
            }
            
        }
        if segue.identifier == "toNew"{
            let newrecordTarget = segue.destination as! EditEntryViewController
            newrecordTarget.contact = DataManager.newRecord(firstName: "", secondName: "", dob: Date(), phones: [String](), addresses: [String](), emails: [String]())
            newrecordTarget.isNew = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toRecord", sender: tableView.cellForRow(at: indexPath))
    }
}
