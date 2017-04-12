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
        let ref = FIRDatabase.database().reference()
        let mydata = "meme"
        eventTxt = typeOfEventLabel.text!
        eventDesc = descriptionLabel.text!
        eventTime = timeLabel.text!
        locationSuper = location
        timestamp = time
        print(locationSuper)
        /*ref.child("events").child(eventTime).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                location = value["location"] as! Array<CLLocationDegrees>
         
            }
        })*/
        
        if (delegate != nil){
            delegate.callSegueFromCell(myData: mydata as AnyObject)
        }

    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfEventLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
        //var time: Double!
    }
var events: Array<String> = []
var descriptions : Array<String> = []
var locations : Array<Array<CLLocationDegrees>> = []
var time : Array<Int> = []
var email : Array<String> = []
//var resolved: Array<Int> = []

class NewFeedTableViewController: UITableViewController, MyCustomCellDelegator{
    var ref : FIRDatabaseReference!
    
    @IBOutlet var eventTableView: UITableView!
    func  callSegueFromCell(myData dataobject: AnyObject){
        self.performSegue(withIdentifier: "ToUpdates", sender: dataobject)
    }
    override func viewDidLoad() {
        
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        events = []
        descriptions = []
        locations = []
        time = []
        email  = []
        
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference()
        ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
          
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let date = Date().timeIntervalSinceReferenceDate
                let value = rest.value as? NSDictionary

                let resolved = (value!["resolved"] as? Int)!
                    
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
                if difference/60 > 24{
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
           
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
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
        
        //typeOfEventText = eventName
       

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
    
/*
        let myVC = storyboard?.instantiateViewController(withIdentifier: "EventUpdateVC") as! EventUpdateViewController
        let cell = tableView.cellForRow(at: <#T##IndexPath#>)
        myVC.eventUpdateLabel.text = typefOfEventText
        navigationController?.pushViewController(myVC, animated: true)
        */
    
    

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        

}
