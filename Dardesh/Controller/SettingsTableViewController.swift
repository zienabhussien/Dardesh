//
//  SettingsTableViewController.swift
//  Dardesh
//
//  Created by Zienab on 23/05/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userStatusLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var appVersionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = nil
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showUserInfo() 
    }
    
    @IBAction func tellAfriendBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func logOutBtnAction(_ sender: UIButton) {
        
        FUserListener.shared.logOutCurrentUser { error in
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
                loginView.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(loginView, animated: true)
                }
                
            }
        }
    }
    @IBAction func termisAndConditionsBtnAction(_ sender: Any) {
    }
    
    
    //MARK:- Update UI
    
    private func showUserInfo(){
        if let user = User.currentUser{
            userNameLbl.text = user.userName
            userStatusLbl.text = user.status
            appVersionLbl.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" )"
            
            if user.avatarLink != "" {
                // download and set avatar image
            }
        }
            
    }
    
 
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 0.10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
   
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableView")
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "SettingsToEditProfileSegue", sender: self)
        }
    }
}
