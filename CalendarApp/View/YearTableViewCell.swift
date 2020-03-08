//
//  YearTableViewCell.swift
//  CalendarApp
//
//  Created by Shankar Suman on 01/03/20.
//  Copyright © 2020 Shankar Suman. All rights reserved.
//

import UIKit

class YearTableViewCell: UITableViewCell {
    
    var completionRightButton: () -> () = {}
    var completionLeftButton: () -> () = {}
    
    @IBOutlet weak var yearDisplay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Now you can change the year")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }
    
    @IBAction func leftClickButton(_ sender: Any) {
        completionLeftButton()
    }
    
    @IBAction func rightClickButton(_ sender: Any) {
        completionRightButton()
    }
    
}
