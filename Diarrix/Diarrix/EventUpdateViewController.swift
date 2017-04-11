//
//  EventUpdateViewController.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/9/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase

class EventUpdateViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var eventUpdateLabel: UILabel!
    @IBOutlet weak var timeUpdateLabel: UILabel!
    @IBOutlet weak var descriptionUpdateLabel: UILabel!
    var eventLabel = ""
    var eventTime = ""
    var descriptionLabel = ""
    var timestamp = ""
    var ref : FIRDatabaseReference!
    
    @IBAction func closeEventUpdateView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func resolveEvent(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        ref.child("events").child(timestamp).updateChildValues(["resolved" : 1])
        let alertController = UIAlertController(title: "Success", message: "The event has been resolved", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
     
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        eventUpdateLabel.text! = eventLabel
        timeUpdateLabel.text! = eventTime
        descriptionUpdateLabel.text! = descriptionLabel

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDescUp"){
            let vc = segue.destination as! UpdateViewController
            vc.timestamp = timestamp
            
        }
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
