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


class ResolvedFeedTableViewController: UITableViewController {
    var resolvedEventArray = [Event]()
    var locationManagerSuper = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let selfCoords = [locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude]
        ref.child("resolvedEvents").observeSingleEvent(of: .value, with: { snapshot in
            
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                let resolvedEvent = Event()
                
                let value = rest.value as? NSDictionary

                resolvedEvent.eventName = value!["typeCrime"] as? String ?? ""
                resolvedEvent.description = value!["description"] as? String ?? ""
                resolvedEvent.email = value!["email"] as? String ?? ""
                resolvedEvent.location = (value!["location"] as? Array<CLLocationDegrees>)!
                resolvedEvent.time = Int(value!["date"] as? String ?? "")!
                self.resolvedEventArray.append(resolvedEvent)
                
            }

          self.tableView.reloadData()
        })
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (resolvedEventArray.count)
    }
    var typeOfEventText: String = ""
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resolvedCell", for: indexPath) as! resolvedFeedTableViewCell
        
        let resolvedEvent = resolvedEventArray[indexPath.row]
        
        let eventName = resolvedEvent.eventName
        let descName = resolvedEvent.description
        
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
