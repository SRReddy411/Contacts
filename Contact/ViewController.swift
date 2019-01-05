//
//  ViewController.swift
//  Contact
//
//  Created by Colors on 11/24/16.
//  Copyright © 2016 Colors. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
class ViewController: UIViewController,CNContactPickerDelegate {
    
    
    var store = CNContactStore()
     var contacts = [CNContact]()
     var updateContact = CNContact()
    
    

    @IBAction func viewContactsAction(_ sender: AnyObject) {
        let contactPickerViewController = CNContactPickerViewController()
         contactPickerViewController.delegate = self
        present(contactPickerViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          // splash screen
        
        
        let animatedSplashScreen = UIImageView(frame: UIScreen.main.bounds)
        self.view.addSubview(animatedSplashScreen)
        animatedSplashScreen.animationImages = [UIImage(named: "full_moon_wallpaper.jpeg")!,  ]
        animatedSplashScreen.animationRepeatCount = 1
        animatedSplashScreen.animationDuration = 5
        animatedSplashScreen.startAnimating()
        self.perform(#selector(self.hideSplash), with: animatedSplashScreen, afterDelay: 5.0)
        // this is for open the contact 
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            
            return
        }
        
     
        
        
        self.store.requestAccess(for: .contacts) { granted, error in
            
            guard granted else {
                DispatchQueue.main.async(execute: {
                    print(error)
                })
                return
            }
 // this is for fetch the contacts details 
            
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey as CNKeyDescriptor])
        do {
            try self.store.enumerateContacts(with: request) { contact, stop in
                
                print("contact:\(contact)")
                self.contacts.append(contact)
            }
        } catch {
            print(error)
        }
        }
        
        //MARK:- FEATCHING ALL CONTACTS NAMES AND MOBILE NUMBERS
        
        fetchContacts(completion: {contacts in
            contacts.forEach({print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil")")})})
        
        
        
//
//        let formatter = CNContactFormatter()
//        formatter.style = .fullName
//
//
//        for contact in self.contacts {
//            let firstName=String(format:"%@",contact.givenName)
//                       print("first:\(firstName)")
//            if (!contact.phoneNumbers.isEmpty) {
//
//                for phoneNumber in contact.phoneNumbers {
//                    if let phoneNumberStruct = phoneNumber.value as? CNPhoneNumber {
//                        let phoneNumberString = phoneNumberStruct.stringValue
//                        print("mobile num :\(phoneNumberString)")
//
//                    }
//                }
//            }
//        }
//
//
//        for contact in self.contacts {
//            print(formatter.string(from: contact) ?? "")
//
//            let firstName=String(format:"%@",contact.givenName)
//            print("first:\(firstName)")
//            let mobilNum = contact.phoneNumbers[0].value(forKey: "digits") as! String
//            print("mobile num:\(mobilNum)")
//
//
//
//        }

        

             }
   
    func hideSplash(_ object: Any) {
        let animatedImageview = (object as! UIImageView)
        animatedImageview.removeFromSuperview()
        
        
    }
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = .userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results)
                }else{
                    print("Error \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

