//
//  FUserListener.swift
//  Dardesh
//
//  Created by Zienab on 21/05/2023.
//

import Foundation
import Firebase
class FUserListener{
    
    static let shared = FUserListener()
    private init(){}
    
    
    // register
    func registerUserWith(email: String,password: String,completion: @escaping(_ error: Error?)-> Void){
        
        Auth.auth().createUser(withEmail: email, password: password){ authResults,error in
            
            completion(error)
            
            if error == nil{
                authResults?.user.sendEmailVerification(completion: { error in
                    completion(error)
                })
                
            }
            if authResults?.user != nil {
                let user = User(id: authResults!.user.uid, userName: email, email: email, pushId: "", avatarLink: "", status: "Hey, I am using dardesh")
                
                self.saveUserToFireStore(user)
                
            }
            
        }
    }
    
    // loginUser
    func loginUserWith(email: String, password: String, completion:@escaping(_ error:Error?,_ isEmailFerivied: Bool )-> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResults, error) in
            
            if error == nil && authResults!.user.isEmailVerified {
                completion(error,true)
                self.downloadUserFromFireStore(userId: authResults!.user.uid)
                
            }else{
                completion(error,false)
            }
        }
        
    }
    
    // resend link verification func
    func resendVerficationEmailwith(email: String, completion: @escaping(_ error: Error?)-> Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    
   // reset password func
    func resetPasswordFor(email: String, completion: @escaping(_ error: Error?)-> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    
    // logOut current user
    func logOutCurrentUser(completion: @escaping(_ error: Error?)-> Void){
        
        do{
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
            
        }catch let error as NSError {
            completion(error)
        }
        
    }
    
    
     func saveUserToFireStore(_ user: User){
        do{
           try FireStoreReference(.User).document(user.id).setData(from: user)
        }catch{
            print(error.localizedDescription)
        }
    }
   
    private func downloadUserFromFireStore(userId: String){
        
        FireStoreReference(.User).document(userId).getDocument { (document, error) in
            
            guard let userDocument = document else{
                print("no data found")
                return
            }
            
            let result = Result{
                try? userDocument.data(as: User.self)
            }
          
            switch result {
            case .success(let userObject):
                if let user = userObject{
                    saveUserLocally(user)
                }else{
                   print("Document does not exist")
                }
                
            case.failure(let error):
                print("error decoding user",error.localizedDescription)
            }
            
        }
        
    }
    
}


