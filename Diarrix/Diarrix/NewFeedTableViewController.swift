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

var eventTxt = ""
var eventDesc = ""
var eventTime = ""
var timestamp = ""
var locationSuper = [0.0, 0.0]

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}

class newFeedTableViewCell: UITableViewCell{
    var delegate:MyCustomCellDelegator!
    var location: Array<CLLocationDegrees>!
    var time: String!
    
    @IBAction func InfoButton(_ sender: Any) {
        
        print("pushed")
        
        let mydata = "meme"
        eventTxt = typeOfEventLabel.text!
        eventDesc = descriptionLabel.text!
        eventTime = timeLabel.text!
        locationSuper = location
        timestamp = time
        print(locationSuper)
        
        if (delegate != nil){
            delegate.callSegueFromCell(myData: mydata as AnyObject)
        }

    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfEventLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    }
var events: Array<String> = []
var descriptions : Array<String> = []
var locations : Array<Array<CLLocationDegrees>> = []
var time : Array<Int> = []
var email : Array<String> = []


class NewFeedTableViewController: UITableViewController, MyCustomCellDelegator{
    var ref : FIRDatabaseReference!
    
    @IBOutlet var eventTableView: UITableView!
    func  callSegueFromCell(myData dataobject: AnyObject){
        self.performSegue(withIdentifier: "ToUpdates", sender: dataobject)
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
       
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        events = []
        descriptions = []
        locations = []
        time = []
        email  = []
        print("ran")
        let ref = FIRDatabase.database().reference()
        ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
            
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let date = Date().timeIntervalSinceReferenceDate
                let value = rest.value as? NSDictionary
                
                let eventTime = ((value!["date"] as? Int)!)
                timestamp = "\(eventTime)"
                let difference = (Int(date) - eventTime)/60
                if difference/60 < 24{
                    events.append(value!["typeCrime"] as? String ?? "")
                    descriptions.append(value!["description"] as? String ?? "")
                    email.append(value!["email"] as? String ?? "")
                    locations.append((value!["location"] as? Array<CLLocationDegrees>)!)
                    time.append((value!["date"] as? Int)!)
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
        return (events.count)
    }
    var typeOfEventText: String = ""
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = Date().timeIntervalSinceReferenceDate
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! newFeedTableViewCell
        cell.delegate = self
    
        let eventTime = time[indexPath.row]
        let eventName = events[indexPath.row]
        let descName = descriptions[indexPath.row]
        
        cell.typeOfEventLabel?.text = eventName
        cell.descriptionLabel?.text = descName
        cell.location = locations[indexPath.row]
        cell.time = "\(time[indexPath.row])"
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
            print(locationSuper)
            vc.eventLabel = eventTxt
            
            vc.newlocation = locationSuper
            vc.eventTime = eventTime
            vc.timestamp = timestamp
            print(timestamp)
            vc.descriptionLabel = eventDesc
        }
    }
}
