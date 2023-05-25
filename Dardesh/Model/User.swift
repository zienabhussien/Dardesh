//
//  User.swift
//  Dardesh
//
//  Created by Zienab on 21/05/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable{
    var id = ""
    var userName: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentUser: User?{
        if Auth.auth().currentUser != nil{
            if let data = userDefaults.data(forKey: kCURRENTUSER){
                do{
                    var userObject = try JSONDecoder().decode(User.self, from: data)
                    return userObject
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        return nil
    }
}

func saveUserLocally(_ user: User){
    do{
        let data = try JSONEncoder().encode(user)
        userDefaults.set(data, forKey: kCURRENTUSER)
        
    }catch{
        print(error.localizedDescription)
    }
}
