//
//  Reminder.swift
//  CalendarApp
//
//  Created by Shankar Suman on 05/03/20.
//  Copyright © 2020 Shankar Suman. All rights reserved.
//

import Foundation

struct Reminder: Codable {
    let year: Int
    let month: Int
    let day: Int
    let events: [String]
    
    
}
