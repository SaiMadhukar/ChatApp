//
//  ForgotPasswordViewController.swift
//  ChatApp
//
//  Created by Sai Madhukar on 12/03/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @objc var picker  = UIImagePickerController()
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var phoneNoField: UITextField!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var usersPhoto: UIImageView!
    
    
    @IBAction func ImagePressed(_ sender: UIButton) {
        
        print("Image Tapped")
        
        let alert = UIAlertController(title: "Profile Pic", message: "Select Profile Pic from?", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
            
            
        }
        let library = UIAlertAction(title: "Phtot Library", style: .default) { (action) in
            
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        alert.addAction(camera)
        alert.addAction(library)
        present(alert, animated: true, completion: nil)
        sender.titleLabel?.text = ""
    }
    
    
    
/*    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.profilePic.image = choosenImage
            self.profilePic.contentMode = .center
            self.profilePic.clipsToBounds = true
            self.profilePic.alpha = 1
            
        }
        else{
            
            outputLabel.text = "Failed to Select Image"
        }
        
        dismiss(animated: true, completion: nil)
        
    }
   */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    
        let storageRef = Storage.storage().reference(forURL: "gs://chatapp-86813.appspot.com/")
        let dataBaseRef = Database.database().reference()

        usersPhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        usersPhoto.contentMode = .scaleAspectFit
        usersPhoto.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(usersPhoto.image!, 0.8)! as NSData
        // set upload path
        let filePath = "\(Auth.auth().currentUser!.uid)/usersPhoto"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                print(downloadURL)
                print("Image uploaded successfully")
                
                //store downloadURL at database
                dataBaseRef.child("Users").child(Auth.auth().currentUser!.uid).updateChildValues(["profilePic": downloadURL])
            }
            
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func JoinButtonPressed(_ sender: UIButton) {
        
        
        if Email.text != nil && passwordField.text != nil && phoneNoField.text != nil && fullName.text != nil // && usersPhoto.image != nil
        {
            
            Auth.auth().createUser(withEmail: Email.text! , password: passwordField.text! )
            {
                
                (auth,error) in
                
                print()
                
                if error == nil {
                    
                    self.createADatabaseForNewUser(UID: (auth?.uid)!)
                    
                    
                    
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    }
                
            }
        
        }
        else{
            outputLabel.text  = "Please Fill All Fileds"
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }

    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "login"
        {
            ViewController.message = "Your Account is Created Successfuly"
            print("done")
        }
    }
    
    
    @objc func createADatabaseForNewUser(UID: String)
    {
        
        let database = Database.database().reference()
        let firebase = database.child("Users")
       // let mail = database.child("EmailIds")
        let names = database.child("Usersnames")
        let phonenos = database.child("PhoneNo")
       // let profilePicsRef = database.child("ProfilePicsRef")
        
        
        
      /*
        //saving profile pic to firebase
        let firstorage = FIRStorage.storage().reference(forURL: "gs://chatapp-86813.appspot.com/")
        let path =  NSURL(fileURLWithPath: "\(UID)/pic.jpg")
        var ImageURL : String!
        let data = UIImageJPEGRepresentation(usersPhoto.image!, 0.8)!
        let metaData = FIRStorageMetadata()
        firstorage.put(data, metadata: metaData) { (metaData, error) in
    
            if let error = error {
                
                print(error.localizedDescription)
                ImageURL = ""
                print("Image Failed to Upload")
            }
            else{
                ImageURL  = metaData!.downloadURL()?.absoluteString
                profilePicsRef.child("\(ImageURL!)").setValue(UID)
                
            }
            
        }
        
        */
        
        
        
        let info : [String: AnyObject] = [
            "name": fullName.text! as AnyObject,
            "Email":Email.text! as AnyObject,
            "phone" : phoneNoField.text! as AnyObject,
            "status" : "offline" as AnyObject,
            "profilePic" : "" as AnyObject
        ]
        print(info)
        
       
        
        
        firebase.child(UID).setValue(info)
        names.child("\(fullName.text!)").setValue(UID)
        phonenos.child("\(phoneNoField.text!)").setValue(UID)
        print("Going Back to login Page")
        print("Account created successfully")
        self.outputLabel.text = "You Account has been Created Successfully"
        ViewController.message = "Your Accout has been Successfully Created"
        
        
    }

        // Do any additional setup after loading the view.
    

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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
