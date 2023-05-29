//
//  EditProfileTableViewController.swift
//  Dardesh
//
//  Created by Zienab on 23/05/2023.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var gallery: GalleryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = nil
        
        configureTextField()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        showUserInfo()
        tableView.reloadData()
    }
    @IBAction func editBtnAction(_ sender: UIButton) {
        showImageGallery()
    }
    
    
    
    private func showUserInfo(){
        if let user = User.currentUser{
            usernameTextField.text = user.userName
            statusLbl.text = user.status
            
            if user.avatarLink != "" {
                // download and set avatar image
                FileStorage.downloadImage(imageUrl: user.avatarLink) { avatarLink in
                    self.userImageView.image = avatarLink?.circleMasked
                }
            }
        }
    }
    
    
    // MARK: - Configure textField
    
    private func configureTextField(){
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField{
            
            if textField.text != "" {
                
                if var user = User.currentUser{
                    user.userName = textField.text!
                    saveUserLocally(user)
                    FUserListener.shared.saveUserToFireStore(user)
                    print("changes saved successfully!")
                }
            }
            return false
        }
        return true
    }
    
    
    // MARK: - Gallery
    private func showImageGallery(){
        
        gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true)
        
    }
    
    
    
   private func uploadAvatarImage(image: UIImage){
       let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
       
       FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
           if var user = User.currentUser{
               user.avatarLink = avatarLink ?? ""
               saveUserLocally(user)
               FUserListener.shared.saveUserToFireStore(user)
           }
        
           FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
       }
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
            performSegue(withIdentifier: "editProfileToStatusSegue", sender: self)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0 : 0.20
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
   

}

extension EditProfileTableViewController : GalleryControllerDelegate{
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        if images.count > 0 {
            images.first?.resolve(completion: { avatarImage in
                if avatarImage != nil {
                    // TODO:- Upload image
                    self.uploadAvatarImage(image: avatarImage!)
                    self.userImageView.image = avatarImage
                    
                }else{
                    ProgressHUD.showError("Couldn't select image")
                }
                
            })
        }
        
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true)

    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true)
    }
    
    
}
