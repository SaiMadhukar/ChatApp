//
//  AfterLogin.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit

class AfterLogin: UIViewController,UITextFieldDelegate {
    
    @objc public var Output = ""
    @objc public static var name = ""

    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Output)
        status.text = Output
        helloLabel.text = "Hello , \(AfterLogin.name)"
        performSegue(withIdentifier: "chatboxes", sender: self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        print(Output)
        status.text = Output
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
