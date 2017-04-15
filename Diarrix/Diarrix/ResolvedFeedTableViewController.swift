//
//  ResolvedFeedTableViewController.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/8/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class resolvedFeedTableViewCell: UITableViewCell{
    
    @IBOutlet weak var typeOfResolvedEventLabel: UILabel!
    @IBOutlet weak var resolvedDescriptionLabel: UILabel!
    

}
var resolvedEvents: Array<String> = []
var resolvedDescriptions : Array<String> = []
var resolvedLocations : Array<Array<CLLocationDegrees>> = []
var resolvedTime : Array<String> = []
var resolvedEmail : Array<String> = []


class ResolvedFeedTableViewController: UITableViewController, CLLocationManagerDelegate{
    let locationManagerSuper = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        resolvedEvents = []
        resolvedDescriptions = []
        resolvedLocations = []
        resolvedTime = []
        resolvedEmail  = []
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = FIRDatabase.database().reference()
        
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
        let selfCoords = [locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude]
        ref.child("resolvedEvents").observeSingleEvent(of: .value, with: { snapshot in
            
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                //let date = Date().timeIntervalSinceReferenceDate
                
                
                let value = rest.value as? NSDictionary
                //let resolved = (value!["resolved"] as? Int)
                //let eventTime = ((value!["date"] as? String)!)
                //let difference = (Int(date) - eventTime)/60
                let testCoords = (value!["location"] as? Array<CLLocationDegrees>)
                let userCoords = selfCoords
                let testLoc = CLLocation(latitude: testCoords![0], longitude: testCoords![1])
                print(testLoc)
                
                let userLoc = CLLocation(latitude: userCoords[0], longitude: userCoords[1])
                print(userLoc)
                let userDist = userLoc.distance(from: testLoc) * 0.000621371
                print("distance: \(userDist)")
                if userDist < 5.0 {
                resolvedEvents.append(value!["typeCrime"] as? String ?? "")
                
                resolvedDescriptions.append(value!["description"] as? String ?? "")
                resolvedEmail.append(value!["email"] as? String ?? "")
                resolvedLocations.append((value!["location"] as? Array<CLLocationDegrees>)!)
                
                resolvedTime.append((value!["date"] as? String ?? ""))
                }
            }
            self.tableView.delegate = self
            self.tableView.dataSource = self
          self.tableView.reloadData()
        })
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (resolvedEvents.count)
    }
    var typeOfEventText: String = ""
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resolvedCell", for: indexPath) as! resolvedFeedTableViewCell
        
        let eventName = resolvedEvents[indexPath.row]
        let descName = resolvedDescriptions[indexPath.row]
        
        cell.typeOfResolvedEventLabel?.text = eventName
        cell.resolvedDescriptionLabel?.text = descName
        
        
        
        
        
        return cell
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
