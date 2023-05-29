//
//  StatusTableViewController.swift
//  Dardesh
//
//  Created by Zienab on 28/05/2023.
//

import UIKit

class StatusTableViewController: UITableViewController {

    let statusList = ["Available","Busy","Sleeping","Dardesh only"]
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statusList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = statusList[indexPath.row]
        
        let userStatus = User.currentUser?.status
        cell.accessoryType = userStatus == statusList[indexPath.row] ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let userStatus = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.reloadData()
        
        print("\(userStatus) selected")
        var user = User.currentUser
        user?.status = userStatus!
        saveUserLocally(user!)
        FUserListener.shared.saveUserToFireStore(user!)
        
    }
    
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    

}
