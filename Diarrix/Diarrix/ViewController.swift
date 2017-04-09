//
//  ViewController.swift
//  Diarrix
//
//  Created by Abhinav Ayalur on 4/8/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(fromURL: "https://diarrix-aa799.firebaseio.com/")

    override func viewDidLoad() {
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
    
    
    
    @IBAction func signUpUser(_ sender: Any) {
        if signUpEmail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: signUpEmail.text!, password: signUpPassword.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    let user = FIRAuth.auth()?.currentUser
                    let uid = user?.uid
                    let usersRef = self.ref.child("users").child(uid!)
                    let values = ["firstName": self.signUpFirstName.text!, "lastName": self.signUpLastName.text!, "Email": self.signUpEmail.text!, "phoneNumber": self.signUpPhoneNumber.text!, "Password": self.signUpPassword.text!]
                    usersRef.ref.updateChildValues(values, withCompletionBlock: { (error, ref)
                        in
                        if error != nil{
                            print(error)
                            return
                        }
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
}
    


