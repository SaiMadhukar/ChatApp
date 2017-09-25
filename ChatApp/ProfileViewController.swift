//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseStorage


extension UIView{
    func addVisualConstraints(pattern: String, Views: UIView...)
    {
        var d = [String : UIView]()
        for (index,view) in Views.enumerated()
        {
            let key = "v\(index)"
            d[key] = view
        }
     //   print(d)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: pattern, options: NSLayoutFormatOptions(), metrics: nil, views: d))
    }
}

extension UIImageView {
    @objc public func imageFromServerURL(urlString: String,ImageName filename: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
               print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image!
                let rawJPG = UIImageJPEGRepresentation(image!, 0.5)
                var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                path!.appendPathComponent(filename+".jpg")
                if rawJPG != nil{
                    
                     try! rawJPG!.write(to: path!)
              //      print("image successfully witten to user file system")
                }
                else{
                    print("Image failed to Download")
                }
            })
        }).resume()
    }
    
    @objc public func ImageFromLocalFileSystem(Localpath path: String, GlobalPath url: String,ImageName name: String)
    {
        if FileManager.default.fileExists(atPath: path)
        {
          //  print(path)
            self.image = UIImage(contentsOfFile: path)
            return
        }
        else{
            imageFromServerURL(urlString: url, ImageName: name)
        }
    
    
    }
}

class ProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    @objc let uid = phone.getUid()
    @objc var ImageView : UIImageView!
   // var info  = [NSManagedObject]()
    @objc var info : NSCache<NSString,NSString> = NSCache()
    @objc var tableView: UITableView!
    @objc var imageUrl = ""
    @objc var infoArray : [String]?
    @objc var path: URL!
    
    
    
    @objc func getManagedContext() -> NSManagedObjectContext
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.persistentContainer.viewContext
        return managedContext
    }
    
    @objc var logout : UIButton!
    
    override func loadView() {
        super.loadView()
        getFromInternet()
    }
    
    
        
    @objc func getFromInternet(){
        let firebase = Database.database().reference()
        let user = firebase.child("Users/\(uid)")
        user.observeSingleEvent(of: .value, with: { (snapshot) in
           // print(snapshot)
            let value = snapshot.value as? NSDictionary
            let picUrl = value?["profilePic"] as? String
            let s = (value?["name"] as! String) + "....." + (value?["Email"] as! String) + "....." + (value?["phone"] as! String) + "....." + (value?["profilePic"] as! String)
            self.info.setObject(s as NSString, forKey: "info")
            self.infoArray = s.components(separatedBy: ".....")
            self.imageUrl = picUrl!
            self.displayImage()
            self.tableView.reloadData()
            
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        displayImage()
    }
    
    @objc func displayImage()
    {
        if(infoArray?.last != nil)
        {
            let localPath = (self.getDirectoryPath() as NSString).appendingPathComponent("profilePic.jpg")
          //  print(infoArray!.last  )
            self.ImageView.ImageFromLocalFileSystem(Localpath: localPath, GlobalPath: (infoArray!.last)!, ImageName: "profilePic")
        }
        else{
            print("info array is empty")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationController?.title = "Profile"
        ImageView = UIImageView()
        ImageView.image = #imageLiteral(resourceName: "Layer1 2")
        ImageView.contentMode = .scaleAspectFit
        view.addSubview(ImageView)
        let height = self.view.bounds.height / 2 - 50
       // print(self.view.bounds.width)
      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": ImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-65-[v0(\(height))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": ImageView]))
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        //Logout Button
        logout = UIButton(frame: CGRect(x: 20 , y: self.view.bounds.height / 2 + 20, width: self.view.bounds.width - 40 , height: 40))
        logout.backgroundColor = .red
        logout.setTitle("Logout", for: UIControlState.normal)
        logout.layer.cornerRadius = 20
        logout.titleLabel!.font = UIFont(name: "Avenir", size: 30)
        logout.titleLabel!.textColor = UIColor.blue
        view.addSubview(logout)
        logout.addTarget(self, action: #selector(logoutPressed), for: UIControlEvents.touchUpInside)
        setTableView()
    }
    
    
    @objc func setTableView()
    {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "info")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        view.addVisualConstraints(pattern: "H:|[v0]|", Views: tableView)
        view.addVisualConstraints(pattern: "V:[v0(200)]-50-|", Views: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  print(info)
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "info")!
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "Avenir", size: 30)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.purple
        cell.isHighlighted = true
        if infoArray == nil{
            cell.textLabel?.text = "......"
            print("getting from internet")
            getFromInternet()
            displayImage()
            return cell
        }
        cell.textLabel?.text = infoArray?[indexPath.row]
                   return cell
        
    }
    
    @objc func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    @objc func logoutPressed()
    {
        
       // print("user wants to logout")
        
        let alert = UIAlertController(title: "Logout?", message: "All Your Data Will Be Lost...", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default)
            {       (a) in
                
                self.removeSavedData()
                self.performSegue(withIdentifier: "logout", sender: self)
                
            }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func removeSavedData()
    {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "getallusersuids")
        UserDefaults.standard.removeObject(forKey: "pic")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

