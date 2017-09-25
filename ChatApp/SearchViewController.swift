//
//  SearchViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       navigationController?.title = "Search"
        navigationController?.isToolbarHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var inputText: UITextField!
    
    @IBAction func addToChatList(_ sender: Any) {
        
        if (inputText.text?.isEmpty)!
        {
            message.text = "Please enter the users name"
            return
        }
        else{
            let input = inputText.text!
            let ref = Database.database().reference().child("Usersnames")
            
             ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let a = snapshot.value as? [String : AnyObject]
                {
                    if a[input] != nil{
                        let data = a[input] as! String
                        print(a[input]!)
                        var a = UserDefaults.standard.value(forKey: "getallusersuids") as? [String]
                        a?.append(data)
                        UserDefaults.standard.setValue(a, forKey: "getallusersuids")
                        
                        self.message.text = "User successfuly added to contacts"
                    }
                    else{
                        self.message.text = "User not found"
                    }
                    
                    
                }
                
            })
           
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        message.text = "Enter Username To Search"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


    
}
