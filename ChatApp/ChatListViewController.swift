//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseStorage


class ChatListViewController: UIViewController,UITextFieldDelegate ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @objc var uids = [String]()
    
    @objc func getUids()
    {
        if let a = UserDefaults.standard.value(forKey: "getallusersuids") as? [String]
        {
            uids = a
           
        }
        else{
            print("Failed to load users from deafults")
        }

    }
   
    override func loadView() {
        super.loadView()
       getUids()
    }
    
       
    
    @objc lazy var collectionView :UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self //as! UICollectionViewDataSource
        cv.delegate = self //as! UICollectionViewDelegate
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
        
    }()
    
    @objc var pointer  = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        getUids()
        collectionView.reloadData()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register( contactsCollectionViewCell.self , forCellWithReuseIdentifier: "people")
        let navBarHeight = ((navigationController?.navigationBar.bounds.height)! + 27)
        collectionView.frame = CGRect(x: 1, y: navBarHeight  , width: self.view.bounds.width - 2, height: self.view.bounds.height - navBarHeight)
        title = "Friends"
        navigationController?.title = "Personal Chat's"
        view.addSubview(collectionView)
     //   collectionView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(screenTap)))
        collectionView.addGestureRecognizer(UISwipeGestureRecognizer.init(target: self, action: #selector(screenTap)))
        
    }
    
    @objc func screenTap()
    {
        collectionView.reloadData()
    }
    
    @objc func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    


    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return uids.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let uid = uids[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "people", for: indexPath) as! contactsCollectionViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.backgroundColor = .blue
        cell.imageView.frame = cell.bounds
        let firebase = Database.database().reference()
        cell.textLabel.textColor = .white
        let h = cell.bounds.height
        let w = cell.bounds.width
        cell.textLabel.frame = CGRect(x: 0 , y: h - (h * 0.2), width: w, height: h * 0.2)
        cell.textLabel.contentMode = .scaleAspectFit
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        cell.textLabel.font = UIFont(name: "Avenir", size: 20)
        
        cell.textLabel.text = "Loading..."
        if let data = firebase.child("Users").child(uid) as? DatabaseReference
        {
            data.observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let username = value?["name"] as? String ?? " "
                    let imageUrl = value?["profilePic"] as! String
                    cell.textLabel.text = username
                    let localImgPath = (self.getDirectoryPath() as NSString).appendingPathComponent(uid+".jpg")
                    cell.imageView.ImageFromLocalFileSystem(Localpath: localImgPath, GlobalPath: imageUrl, ImageName: uid)
                    print(username + "      ...............                   " + imageUrl)
                })
            { (error) in
                print(error.localizedDescription)
            }
        }
    
        
        return cell
       /* if let d = firebase.child("Users").child(uid) as? FIRDatabaseReference
        {
            d.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? " "
                let picUrl = value?["profilePic"] as! String
                print(picUrl)
                cell.textLabel.text = username
                let localImgPath = (self.getDirectoryPath() as NSString).appendingPathComponent(uid+".jpg")
                cell.imageView.ImageFromLocalFileSystem(Localpath: localImgPath, GlobalPath: picUrl, ImageName: uid)
               
            })
            { (error) in
                print(error.localizedDescription)
            }
 
         } */
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.bounds.width / 2) - 1, height: (self.view.bounds.width / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     let pc = storyboard?.instantiateViewController(withIdentifier: "PersonalChatViewController") as? PersonalChatViewController
        navigationController?.pushViewController(pc!, animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination == PersonalChatViewController()
        {
            let dest = segue.destination as! PersonalChatViewController
            dest.name = "Hello"
            dest.UID = "    "
            
        }
    }

}
