//
//  ViewController.swift
//  ContactFrameworkDaniyal
//
//  Created by Daniyal Yousuf on 10/24/18.
//  Copyright © 2018 Daniyal Yousuf. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {
    var contacts : [CNContact] = []
    @IBOutlet weak var baseTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        baseTableView.rowHeight = 62
        baseTableView.tableFooterView = UIView.init()
        baseTableView.register(UINib.init(nibName: "UserContact", bundle: nil), forCellReuseIdentifier: "usercontact")
        
        fetchContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (request, error) in
          
            if !request {
                print("Provide Request")
            } else {
                let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, pointer) in
                        self.contacts.append(contact)
                    })
                    DispatchQueue.main.async {
                        self.contacts = self.contacts.sorted { $0.familyName < $1.familyName }
                        self.baseTableView.reloadData()
                    }
                } catch let err {
                    print("failed to enumerate \(err)")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercontact") as! UserContact
        cell.lblTitle.text = contacts[indexPath.row].givenName
        
        return cell
    }

}

