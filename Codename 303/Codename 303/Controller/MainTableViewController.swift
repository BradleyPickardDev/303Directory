//
//  MainTableViewController.swift
//  Codename 303
//
//  Created by Bradley Pickard on 8/6/19.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var contacts: Array<JSONParser.Contact>?

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerDataManager.shared.loadFileFromWeb()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .loadFileFromWebComplete, object: nil)
        tableView.register(UINib.init(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
    }
    
    @objc private func reloadTableData() {
        contacts = ServerDataManager.shared.decodedContacts
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! MyTableViewCell
        cell.awakeFromNib()
        return cell
    }
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let contactsArray = contacts else { return }
        let currentContact = contactsArray[indexPath.row]
        let contactCell = cell as! MyTableViewCell
        contactCell.firstNameLabel.text = currentContact.fname
        contactCell.lastNameLabel.text = currentContact.lname
        contactCell.cityLabel.text = currentContact.city
    }

}
