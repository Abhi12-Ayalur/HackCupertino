//
//  ReportViewController.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/9/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ReportViewController: UIViewController, CLLocationManagerDelegate {
    
    var ref: FIRDatabaseReference!
    var email = ""
    var coords: Array<CLLocationDegrees>?
    let locationManagerSuper = CLLocationManager()
    @IBOutlet weak var crType: UITextField!
    @IBOutlet weak var Description: UITextView!
    //@IBOutlet weak var Description: UITextField!
    
    func locationManagerF(manager: CLLocationManager!) -> Array<CLLocationDegrees> {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        return [locValue.latitude, locValue.longitude]
    }
    
    override func viewDidLoad() {
        Description.layer.cornerRadius = 5
        Description.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        Description.layer.borderWidth = 0.5
        Description.clipsToBounds = true
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReportViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.email = value?["Email"] as? String ?? ""
            print(self.email)
            let password = value?["Password"] as? String ?? ""
            print(password)
            
          
        }) { (error) in
            print(error.localizedDescription)
        }
        let locationManager = self.locationManagerSuper
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.coords = locationManagerF(manager: locationManager)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func Submit(_ sender: Any) {
        if crType.text != "" && Description.text != "Description"{
        let date = Date().timeIntervalSinceReferenceDate
        let ref = FIRDatabase.database().reference()
        print(self.coords!)
        print(self.email)
        let values = ["location": self.coords!, "typeCrime": crType.text!, "description": Description.text!, "email": self.email, "date": Int(date), "resolved": 0] as [String : Any]
        
        ref.child("events").child("\(Int(date))").setValue(values)
        let alertController = UIAlertController(title: "Success!", message: "Thank you for your report", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        crType.text! = ""
        Description.text! = ""
        }
    }
    
}
