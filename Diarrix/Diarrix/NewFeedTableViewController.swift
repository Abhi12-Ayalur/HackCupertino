//
//  NewFeedTableViewController.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/8/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation



class NewFeedTableViewController: UITableViewController{
    var ref : FIRDatabaseReference!
    var eventTxt = ""
    var eventDesc = ""
    var eventTime = ""
    var timestamp = ""
    var locationManagerSuper = CLLocationManager()
    var eventArray = [Event]()
    
    var locationSuper:Array<CLLocationDegrees> = [0.0, 0.0]
    var selfCoords:Array<CLLocationDegrees> = [0.0, 0.0]


    @IBOutlet var eventTableView: UITableView!
    
    func  callSegueFromCell(myData dataobject: AnyObject){
        self.performSegue(withIdentifier: "ToUpdates", sender: dataobject)
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
       
        super.viewDidLoad()
        
        
       
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("ran")
        let ref = FIRDatabase.database().reference()
        let locationManager = self.locationManagerSuper
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        selfCoords = [locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude]
        

        ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
            
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let event = Event()
                let date = Date().timeIntervalSinceReferenceDate
                let value = rest.value as? NSDictionary
                
                let eventTime = ((value!["date"] as? Int)!)

                let testCoords = (value!["location"] as? Array<CLLocationDegrees>)
                let userCoords = self.selfCoords
                let testLoc = CLLocation(latitude: testCoords![0], longitude: testCoords![1])
                print(testLoc)
                
                let userLoc = CLLocation(latitude: userCoords[0], longitude: userCoords[1])
                print(userLoc)
                var userDist = userLoc.distance(from: testLoc) * 0.000621371
                userDist = round(userDist * 100.0) / 100.0
                print("distance: \(userDist)")
                let distString = "\(userDist) mins"
                //let
                self.timestamp = "\(eventTime)"
                let difference = (Int(date) - eventTime)/60
                if difference/60 < 24{
                    event.eventName = value!["typeCrime"] as? String ?? ""
                    event.description = value!["description"] as? String ?? ""
                    event.email = value!["email"] as? String ?? ""
                    event.location = (value!["location"] as? Array<CLLocationDegrees>)!
                    event.time = (value!["date"] as? Int)!
                    self.eventArray.append(event)
                    
                    

                }
                
                if difference/60 >= 24{
                    let event = value!["typeCrime"] as? String ?? ""
                    let description = value!["description"] as? String ?? ""
                    let email = value!["email"] as? String ?? ""
                    let location = (value!["location"] as? Array<CLLocationDegrees>)!
                    let time = (value!["date"] as? Int)!
                    let valDict = ["typeCrime": event, "description": description, "location": location, "date": "\(time)"] as [String : Any]
                    ref.child("resolvedEvents").child("\(time)").updateChildValues(valDict)
                    ref.child("events").child("\(time)").setValue(nil)
                }
            }
            self.tableView.reloadData()
            
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventArray.count)
    }
    var typeOfEventText: String = ""
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = Date().timeIntervalSinceReferenceDate
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! NewFeedTableViewCell
        
        
        let event = eventArray[indexPath.row]
    
        let eventTime = event.time
        let eventName = event.eventName
        let descName = event.description
        
        cell.typeOfEventLabel?.text = eventName
        cell.descriptionLabel?.text = descName

        cell.location = event.location

        cell.time = "\(event.time)"

        var difference = (Int(date) - eventTime)/60
        if difference > 60 && difference < 120{
            difference = difference/60
            cell.timeLabel?.text = ("\(difference) hr")
        }
        else if difference > 60  {
            difference = difference/60
            cell.timeLabel?.text = ("\(difference) hrs")
        }
        else{
            cell.timeLabel?.text = ("\(difference) mins")
        }
 
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToUpdates"){
            let vc = segue.destination as! EventUpdateViewController
            
            vc.eventLabel = eventTxt
            
            vc.newlocation = locationSuper
            vc.eventTime = eventTime
            vc.timestamp = timestamp
            
            vc.descriptionLabel = eventDesc
        }
    }
   
    func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath){
        
        
        let eventSelected = self.eventArray[indexPath.row]
        print(eventSelected.description)
        

    }
}
