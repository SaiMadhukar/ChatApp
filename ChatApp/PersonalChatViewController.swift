//
//  PersonalChatViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit

class PersonalChatViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @objc var UID  : String!
     @objc var name = "Chat"
    
    override func loadView() {
        super.loadView()
    }
    @objc var count = 0
    
    @objc var messages = [String]()
    
    @IBAction func send(_ sender: UIButton) {
        
        if inputField.text == nil{
            return
        }
        let msg = inputField.text!
        let length = msg.lengthOfBytes(using: .unicode)
        if length > 0
        {
            messages.append(msg + " ")
            print(messages)
            count += 1
            tableView.reloadData()
        }
        
    }

   // var imageView : UIImageView!
    
    @objc var tableView : UITableView!

    
    @IBOutlet var inputField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chatboxes")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        view.addVisualConstraints(pattern: "H:|[v0]|", Views: tableView)
        view.addVisualConstraints(pattern: "V:|-65-[v0]-50-|", Views: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.tableHeaderView = UIView(frame : CGRect(x: 0, y: 0, width: Int(self.view.bounds.width) , height: 10))
        tableView.separatorStyle = .none
        tableView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeTextInputField)))
        //view.translatesAutoresizingMaskIntoConstraints = false
        print(UID)
        title = name
        

        // Do any additional setup after loading the view.
    }
    
    @objc func closeTextInputField()
    {
        view.endEditing(true)
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatboxes")! as UITableViewCell
        let size = messages[indexPath.row].characters.count * 9
        let x = self.view.bounds.width - CGFloat(size) - CGFloat(20)
        
        let msg = UILabel(frame: CGRect(x: CGFloat(x) , y: CGFloat(5), width: CGFloat(size), height: CGFloat(30)))
        msg.font = UIFont(name: "Avenir", size: 16)
        msg.textColor = UIColor.black
        msg.isHighlighted = true
        msg.layer.cornerRadius = 10
        msg.clipsToBounds = true
        msg.layer.masksToBounds = true
        msg.textAlignment = .center
        msg.adjustsFontSizeToFitWidth = true
        cell.addSubview(msg)
        msg.backgroundColor = UIColor.white
        msg.text = messages[indexPath.row]
        print( "\(indexPath.row)" + " " + messages[indexPath.row])
        inputField.text = ""
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {  
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
