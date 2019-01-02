//
//  DataManager.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/19/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit
import CoreData

class DataManager{
    
    private static var appDelegate:AppDelegate? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }else{
            return nil
        }
    }
    
    private static var managedContext:NSManagedObjectContext? {
        if let managedContext =
            appDelegate?.persistentContainer.viewContext {
            return managedContext
        } else {
            return nil
        }
    }
    
    static func addEmptyRecord (type:CellTypes, contact:Contact) {
        if type == .email{
           _ = addAttribute(value: "", toEntity: contact, targetEntityName: "Email", targetRelationship: "email", targetAttribute: "emailAddress")
        }
        if type == .phone{
            _ = addAttribute(value: "", toEntity: contact, targetEntityName: "Phone", targetRelationship: "phone", targetAttribute: "phonenumber")
        }
    }
    static func fetchRecords() -> [Contact]?{
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        let sort = NSSortDescriptor(key: #keyPath(Contact.secondName), ascending: true)
        
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let  people = try managedContext?.fetch(fetchRequest)
            let contacts = people as? [Contact]
            return contacts
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    static func refetch(with text: String) -> [Contact]?{
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Contact")
        let sort = NSSortDescriptor(key: #keyPath(Contact.secondName), ascending: true)
        
         fetchRequest.sortDescriptors = [sort]
        print(text)
        let predicate = NSPredicate(format: "firstName CONTAINS %@ OR secondName CONTAINS %@", text, text)
       fetchRequest.predicate = predicate
        do {
            let  people = try managedContext?.fetch(fetchRequest)
            let contacts = people as? [Contact]
            return contacts
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    static func addAttribute(value:String, toEntity:Contact, targetEntityName:String, targetRelationship:String, targetAttribute:String) -> Bool {
        guard let context = managedContext, let emailEntity = NSEntityDescription.entity(forEntityName: targetEntityName, in: context) else {
            return false
        }
       
        let emailAddress = NSManagedObject(entity: emailEntity, insertInto: context)
        emailAddress.setValue(toEntity, forKey: targetRelationship)
        emailAddress.setValue(value, forKey: targetAttribute)
        return true
    }
    
    static func deleteRecord(record:NSManagedObject) -> Bool{
        let managedContext = appDelegate?.persistentContainer.viewContext
        managedContext?.delete(record)
        return true
    }
    
    
    static func saveRecords(){
        let managedContext =
            appDelegate?.persistentContainer.viewContext
        try? managedContext?.save()
    }
        
    static func newRecord(firstName:String, secondName:String, dob:Date, phones:[String], addresses:[String], emails:[String]) -> Contact? {
        
        guard let context = appDelegate?.persistentContainer.viewContext,
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
            else {return nil}
        
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        
        newUser.setValue(firstName, forKey: "firstName")
        newUser.setValue(secondName, forKey: "secondName")
        newUser.setValue(dob, forKey: "dob")
        
        //Phones
        for phoneNumber in phones {
            guard let phoneEntity = NSEntityDescription.entity(forEntityName: "Phone", in: context) else { continue }
            let phone = NSManagedObject(entity: phoneEntity, insertInto: context)
            phone.setValue(newUser, forKey: "phone")
            phone.setValue(phoneNumber, forKey: "phonenumber")
        }
        //Addresses
        for addressEntry in addresses {
            guard let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: context) else { continue }
            let address = NSManagedObject(entity: addressEntity, insertInto: context)
            address.setValue(newUser, forKey: "address")
            address.setValue(addressEntry, forKey: "addressEntry")
        }
        //Emails
        for emailEntry in emails {
            guard let emailEntity = NSEntityDescription.entity(forEntityName: "Email", in: context) else { return nil }
            let emailAddress = NSManagedObject(entity: emailEntity, insertInto: context)
            emailAddress.setValue(newUser, forKey: "email")
            emailAddress.setValue(emailEntry, forKey: "emailAddress")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
            return nil
        }
        return newUser as? Contact
    }
}
