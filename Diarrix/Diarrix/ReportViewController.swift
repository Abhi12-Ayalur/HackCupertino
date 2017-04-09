//
//  ReportViewController.swift
//  Diarrix
//
//  Created by Abhinav Ayalur on 4/8/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreLocation

class ReportViewController: UIViewController, CLLocationManagerDelegate {
    let locationManagerSuper = CLLocationManager()
    var eventText = ""
    var eventDescription = ""
    var FirstName = ""
    var LastName = ""
    var email = ""
    
    var location: Array<CLLocationDegrees?> = []
    var ref : FIRDatabaseReference!
    @IBOutlet weak var Incident: UITextField!
    @IBOutlet weak var Description: UITextField!
    func locationManagerF(manager: CLLocationManager!) -> Array<CLLocationDegrees> {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        return [locValue.latitude, locValue.longitude]
    }
    override func viewDidLoad() {
        
        let date = Date().timeIntervalSinceReferenceDate
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(fromURL: "https://diarrix-aa799.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        if let uide = uid{
            var name = uide
            ref.child("users").child(name as String).observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            self.FirstName = (dict?["firstName"] as? String)!
             self.LastName = (dict?["lastName"] as? String)!
                self.email = (dict?["Email"] as?
                    String)!
                
                
             })
            { (error) in
                print(error.localizedDescription)
            }
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
        let coords = locationManagerF(manager: locationManager)
        location = [coords[0], coords[1]]
        let eventsRef = ref.child("events").child("\(date)")
        let values = ["incidentName": Incident, "descriptions": Description, "location": location, "username": self.FirstName, "surname": self.LastName, "email": self.email] as [String : Any]
        eventsRef.ref.updateChildValues(values, withCompletionBlock: { (error, ref)
            in
            
            if error != nil{
                print(error)
                return
            }
        })

        print(location)
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
