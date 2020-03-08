//
//  MonthTableViewCell.swift
//  CalendarApp
//
//  Created by Shankar Suman on 01/03/20.
//  Copyright © 2020 Shankar Suman. All rights reserved.
//

import UIKit

class MonthTableViewCell: UITableViewCell {

    var completionRightButton: () -> () = {}
    var completionLeftButton: () -> () = {}
   
    
    
    
    
    @IBOutlet weak var monthToDisplay: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Now you can change the month")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    @IBAction func leftClickButton(_ sender: Any) {
        completionLeftButton()
    }
    
    @IBAction func rightClickButton(_ sender: Any) {
        completionRightButton()
    }
}
