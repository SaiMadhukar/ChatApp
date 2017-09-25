//
//  ViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 11/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var imageLayer: UIImageView!
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @objc static var message = ""
    
    
    @IBOutlet weak var status: UILabel!
    
    @objc var downloadedPic : UIImage!
    
    @objc static var name = ""
    
    
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        
        
        
       
        if Username.text?.isEmpty == false && Password.text?.isEmpty == false {
            
            print(Username.text!)
            print(Password.text!)
            print("Enterd herre")
            
            Auth.auth().signIn(withEmail: Username.text!, password: Password.text!)
            {
                
                (user,error) in
                
                if user != nil{
                        print("successsfully logged in")
                    
                        //userDefaults
                        UserDefaults.standard.set(self.Username.text!, forKey: "username")
                        UserDefaults.standard.set(self.Password.text!, forKey: "password")
                        let a = [String]()
                        UserDefaults.standard.set(a, forKey: "getallusersuids")
                        self.setupAfterLogin()
                                      }
                else{
                    
                        print("failed")
                        self.status.text = "Username Or Password Is Incorrect"
                    }
            }
        }
        else{
            
        }
    }
    
    override func loadView() {
        super.loadView()
        autoLogin()
        status.text = ViewController.message
        //getting Image From FirStorage
        changeBackground()
        
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func autoLogin()
    {
        
        if let username = UserDefaults.standard.value(forKey: "username") as? String{
            
            if let password = UserDefaults.standard.value(forKey: "password") as? String{
                
                Username.text = username
                Password.text = password
                print(username + password)
                _ = Auth.auth().signIn(withEmail: username, password: password, completion: { (user, error) in
                    
                    if user != nil {
                        print("user logged in succesfully")
                        self.setupAfterLogin()
                    }
                    else{
                        print("User defaults Error")
                    }
                })
            }
            
            
        }
        else{
            
            print("failed to auto login")
            status.text = "Failed to AutoLogin"
        }

    }
    
    
    @objc public func setupAfterLogin()
    {
        
        let userName = UserDefaults.standard.value(forKey: "username") as! String
        ViewController.name = userName
        print(ViewController.name)
        
        if ViewController.name.contains("@")
        {
            ViewController.name = ViewController.name.substring(to: (ViewController.name.characters.index(of: "@"))!)
           // AfterLogin.name = ViewController.name
           print(ViewController.name)
        }
        let database = Database.database().reference()
        let user = database.child("Online")
        user.child(ViewController.name).setValue("Online")
        performSegue(withIdentifier: "chatboxes", sender: self)
    }
    
    
    @objc func changeBackground()
    {
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("Hibernate.jpg")
        
        
        imageRef.getData(maxSize: Int64(0.5 * 1024 * 1024), completion: {
            
            (data,error) in
            
            if let _ = error
            {
                
                let alert = UIAlertController(title: "Error", message: "Unable to load Image From Firebase", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.downloadedPic = UIImage(data: data!)
                self.imageLayer.image = self.downloadedPic
                self.imageLayer.contentMode = .scaleAspectFill
            }
        })
        
        
    }
    
   
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

