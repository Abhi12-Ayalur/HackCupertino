//
//  ProfileViewController.swift
//  Diarrix
//
//  Created by Abhinav Ayalur on 4/12/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    var ref : FIRDatabaseReference!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var EditTapStatic: UIButton!
    @IBAction func EditDoneTap(_ sender: Any) {
        if EditTapStatic.currentTitle == "Edit"{
            FirstName.isUserInteractionEnabled = true
            LastName.isUserInteractionEnabled = true
            PhoneNumber.isUserInteractionEnabled = true
            Email.isUserInteractionEnabled = true
            Password.isUserInteractionEnabled = true
            Password.isSecureTextEntry = false
            EditTapStatic.setTitle("Done", for: .normal)
        }
        else if EditTapStatic.currentTitle == "Done"
        {
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            let values = ["firstName": FirstName.text,"lastName": LastName.text, "Email": Email.text, "phoneNumber": PhoneNumber.text, "Password": Password.text]
            let user = FIRAuth.auth()?.currentUser

            user?.updateEmail(self.Email.text!, completion: {(error) in
                if error != nil {
                    print(error)
                }
                else{
                    user?.updatePassword(self.Password.text!, completion: {(error) in
                        if error != nil{
                            print (error)
                        }
                        else{
                            ref.child("users").child(uid!).updateChildValues(values)
                        }
                    })
                }
            })
            FirstName.isUserInteractionEnabled = false
            LastName.isUserInteractionEnabled = false
            PhoneNumber.isUserInteractionEnabled = false
            Email.isUserInteractionEnabled = false
            Password.isUserInteractionEnabled = false
            Password.isSecureTextEntry = true
            EditTapStatic.setTitle("Edit", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        EditTapStatic.setTitle("Edit", for: .normal)
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        let user = FIRAuth.auth()?.currentUser
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: {(
            snapshot) in
            let value = snapshot.value as? NSDictionary
            self.FirstName.text = value!["firstName"] as? String
            self.LastName.text = value!["lastName"] as? String
            self.Email.text = value!["Email"] as? String
            self.PhoneNumber.text = value!["phoneNumber"] as? String
            self.Password.text = value!["Password"] as? String
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
