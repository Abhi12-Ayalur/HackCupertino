//
//  UpdateViewController.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/9/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase

class UpdateViewController: UIViewController {

    @IBOutlet weak var updateDescriptionField: UITextField!
    var ref : FIRDatabaseReference!
    var timestamp = ""
    @IBAction func updateDescButton(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
      
        ref.child("events").child(timestamp).updateChildValues((["description": updateDescriptionField.text!]))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDescriptionField.borderStyle = UITextBorderStyle.roundedRect
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
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
    func dismissKeyboard() {
        view.endEditing(true)
    }


}
