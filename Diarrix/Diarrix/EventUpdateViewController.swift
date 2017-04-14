//
//  EventUpdateViewController.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/9/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class EventUpdateViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var eventUpdateLabel: UILabel!
    @IBOutlet weak var timeUpdateLabel: UILabel!
    @IBOutlet weak var descriptionUpdateLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    var eventLabel = ""
    var eventTime = ""
    var descriptionLabel = ""
    var timestamp = ""
    var userlocation = [0.0, 0.0]
    var newlocation = [0.0, 0.0]
    var update = ""
    var ref : FIRDatabaseReference!
    var locationManager : CLLocationManager!
    
    @IBAction func closeEventUpdateView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func resolveEvent(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        print(timestamp)
        print("hello")
        ref.child("events").child(timestamp).setValue(nil)
        let resolvedVals = ["location": userlocation, "typeCrime": eventLabel, "description": descriptionLabel, "date": timestamp] as [String : Any]
        ref.child("resolvedEvents").child(timestamp).updateChildValues(resolvedVals)
        let alertController = UIAlertController(title: "Success", message: "The event has been resolved", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        let locationManagerSuper = CLLocationManager()
        super.viewDidLoad()
        print(newlocation)
        locationManagerSuper.requestAlwaysAuthorization()
        locationManagerSuper.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManagerSuper.delegate = self
            locationManagerSuper.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManagerSuper.startUpdatingLocation()
            userlocation = [(locationManagerSuper.location?.coordinate.latitude)!, (locationManagerSuper.location?.coordinate.longitude)!]
            let userCoord = CLLocation(latitude: userlocation[0], longitude: userlocation[1])
            let regionRadius: CLLocationDistance = 50*1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(userCoord.coordinate, regionRadius*2.0, regionRadius*2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            let userPin = MKPointAnnotation()
            userPin.coordinate = CLLocationCoordinate2D(latitude: userlocation[0], longitude: userlocation[1])
            userPin.title = "Your Location"
            
            let newPin = MKPointAnnotation()
            newPin.coordinate = CLLocationCoordinate2D(latitude: newlocation[0], longitude: newlocation[1])
            newPin.title = eventLabel
            newPin.subtitle = descriptionLabel
            mapView.showsUserLocation = true
            mapView.addAnnotation(newPin)
            print(userlocation)
        }
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        eventUpdateLabel.text! = eventLabel
        timeUpdateLabel.text! = eventTime
        //descriptionUpdateLabel.text! = descriptionLabel
        descriptionText.text! = descriptionLabel

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDescUp"){
            let vc = segue.destination as! UpdateViewController
            print(timestamp)
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
