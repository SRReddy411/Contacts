//
//  AddContactsViewController.swift
//  Contact
//
//  Created by Colors on 11/24/16.
//  Copyright © 2016 Colors. All rights reserved.
//

import UIKit
import Contacts
class AddContactsViewController: UIViewController {
    
    
    var updateContact = CNContact()
    var isUpdate: Bool = false

    @IBOutlet var mobileNumText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var nameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addContactsButton(_ sender: AnyObject) {
         var newContact = CNMutableContact()
        if isUpdate == true {
            newContact = updateContact.mutableCopy() as! CNMutableContact
        }
        
        //Set Name
        newContact.givenName = nameText.text!
        let phoneNo = CNLabeledValue(label:CNLabelPhoneNumberMobile, value:CNPhoneNumber(stringValue:mobileNumText.text!))
        
        if isUpdate == true {
            newContact.phoneNumbers.append(phoneNo)
        } else {
            newContact.phoneNumbers = [phoneNo]
        }
        
        //Set Email
        
        
        let workEmail = CNLabeledValue(label:"Work Email", value:(emailText.text ?? "") as NSString)
        if isUpdate == true {
            newContact.emailAddresses.append(workEmail)
        }else{
            newContact.emailAddresses = [workEmail]
        }

        
        
        var message: String = ""
        do {
            let saveRequest = CNSaveRequest()
            if isUpdate == true {
                saveRequest.update(newContact)
                message = "Contact Updated Successfully"
            } else {
                saveRequest.add(newContact, toContainerWithIdentifier: nil)
                message = "Contact Added Successfully"
            }
            
            let contactStore = CNContactStore()
            try contactStore.execute(saveRequest)
            
            displayAlertMessage(message, isAction: true)
        }
        catch {
            if isUpdate == true {
                message = "Unable to Update the Contact."
            } else {
                message = "Unable to Add the New Contact."
            }
            
            displayAlertMessage(message, isAction: false)
        }

    }
    func displayAlertMessage(_ message: String, isAction: Bool) {
        let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) -> Void in
            if isAction == true {
                return
            }
        }
        
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
