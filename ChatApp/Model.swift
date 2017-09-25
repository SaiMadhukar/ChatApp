//
//  Model.swift
//  Pods
//
//  Created by Sai Madhukar on 14/03/17.
//
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import CoreData


public struct User {

    var name : String
    var email : String
    var phone : String
    var uid : String
    var photoUrl: String
}


public class phone
{
    static func getUid() -> String
    {
        let auth = Auth.auth().currentUser?.uid
        return auth!
    }
}

public class UsersInfo
{
    
    
    var uid : String
    let firebase = Database.database().reference()

    init(UID:String)
    {
        self.uid = UID
    }
    
    
    func isAValidUser() -> Bool
    {
        if (Database.database().reference().child("Users/\(uid)") as? DatabaseReference) != nil
        {
            return true
        }
        else{
            return false
        }
        
    }
    
    
    internal func getDetails() -> User?
    {
        
        var a : User?
        
        if let data = firebase.child("Users").child(uid) as? DatabaseReference
        {
            data.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? " "
                let email = value?["Email"] as? String ?? " "
                let phone = value?["phone"] as? String ?? " "
                let imageUrl = value?["profilePic"] as? String ?? " "
                a = User.init(name: username, email: email, phone: phone, uid: self.uid, photoUrl: imageUrl)
                print(imageUrl)
            })
            { (error) in
                print(error.localizedDescription)
            }
            return a
        }
        else{
            print("No users exists with that UID")
            return a
        }
        
    }
    
}
