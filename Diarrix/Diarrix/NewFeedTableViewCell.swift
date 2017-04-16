//
//  NewFeedTableViewCell.swift
//  Diarrix
//
//  Created by Ishaan Singhal on 4/15/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import CoreLocation

class NewFeedTableViewCell: UITableViewCell{
   
    var location: Array<CLLocationDegrees>!
    var time: String!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfEventLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
}
