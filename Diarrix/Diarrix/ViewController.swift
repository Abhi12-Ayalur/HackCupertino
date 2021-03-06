//
//  ViewController.swift
//  Diarrix
//
//  Created by Abhinav Ayalur on 4/8/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    var ref : FIRDatabaseReference!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        super.viewDidLoad()
       

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var signUpFirstName: UITextField!
    @IBOutlet weak var signUpLastName: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPhoneNumber: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    
    @IBOutlet weak var signUpConfirmPassword: UITextField!
    
    
    @IBAction func signUpUser(_ sender: Any) {
        let ref = FIRDatabase.database().reference(fromURL: "https://diarrix-aa799.firebaseio.com/")
        if signUpEmail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else if  signUpPassword.text! != signUpConfirmPassword.text!{
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: signUpEmail.text!, password: signUpPassword.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    let user = FIRAuth.auth()?.currentUser
                    var name = ""
                    if let uid = user?.uid{
                        name = uid
                        print(name)
                    }
                    let usersRef = ref.child("users").child(name)
                    let values = ["firstName": self.signUpFirstName.text!, "lastName": self.signUpLastName.text!, "Email": self.signUpEmail.text!, "phoneNumber": self.signUpPhoneNumber.text!, "Password": self.signUpPassword.text!]
                    usersRef.ref.updateChildValues(values, withCompletionBlock: { (error, ref)
                        in
                        
                        if error != nil{
                            
                            return
                        }
                        self.performSegue(withIdentifier: "SignUpToTab", sender: self)
                    })
                    
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBAction func loginUser(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: loginEmail.text!, password: loginPassword.text!, completion: { (user, error)
            in
            if error != nil{
                let alertController = UIAlertController(title: "Incorrect Email or Password", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.performSegue(withIdentifier: "LoginToTab", sender: self)
            }
        })
        
    }

}



