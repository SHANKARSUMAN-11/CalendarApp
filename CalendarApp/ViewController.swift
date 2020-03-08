//
//  ViewController.swift
//  CalendarApp
//
//  Created by Shankar Suman on 29/02/20.
//  Copyright © 2020 Shankar Suman. All rights reserved.
//

import UIKit
protocol DateProtocol {
    func getDateSpecs() -> (year: Int, month: Int, dat: Int)
    func getEvents(pressedYear: Int, pressedMonth: Int, pressedDay: Int)
}

enum Sections: Int {
    
    case yearandmonth
    case events
    
}

//var globalDate = Date()

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,DateProtocol {
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    func dateFromDayMonthYear(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)!
    }
    
    lazy var eventMessages: [String] = [("Today is \(getFormattedDate(date: self.globalDate, format: "dd-MMM-yyyy"))")]
    
    func getEvents(pressedYear: Int, pressedMonth: Int, pressedDay: Int) {
        eventMessages.removeAll()
        eventMessages.append(("Today is \(getFormattedDate(date: dateFromDayMonthYear(year: pressedYear, month: pressedMonth, day: pressedDay), format: "dd-MMM-yyyy"))"))
        self.reminders.forEach { (reminder) in
            if pressedYear == reminder.year && pressedMonth == reminder.month && pressedDay == reminder.day {
                eventMessages = reminder.events
            }
        }
        self.tableView.reloadData()
        
        // eventMessages.append(("Today is \(getFormattedDate(date: self.globalDate, format: "dd-MM-yyyy"))"))
        
    }
    
    
    var reminders = [Reminder]()
    
    func getDateSpecs() -> (year: Int, month: Int, dat: Int) {
        let cyear = self.currentDateStatus.year
        let cmonth = self.currentDateStatus.month
        let cdate = self.currentDateStatus.dat
        
        return (cyear, cmonth, cdate)
    }
    
    var tableViewCell: TableViewCell = TableViewCell()
    var monthComponents = Calendar.current.standaloneMonthSymbols
    var globalDate = Date()
    var dateComponents = DateComponents()
    
    func dateStatus(today: Date) -> (year: Int, month: Int, dat: Int, WeekDay: Int) {
        let year = Calendar.current.component(.year, from: today)
        let month = Calendar.current.component(.month, from: today)
        let date = Calendar.current.component(.day, from: today)
        let weekDay = Calendar.current.component(.weekday, from: today)
        return (year, month, date, weekDay)
    }
    
    
    lazy var currentDateStatus = self.dateStatus(today: globalDate)
    
    @IBOutlet var tableView: UITableView!
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections: Sections = Sections(rawValue: section) {
            switch sections {
                
            case .yearandmonth:
                return 2
            case .events:
                return eventMessages.count
            
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return UIScreen.main.bounds.width - CGFloat(0) // just make it for 1 section
        }
        return CGFloat(0)
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    //        return UIScreen.main.bounds.width
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            if(indexPath.row % 2 == 0){
                if let cell = tableView.dequeueReusableCell(withIdentifier: "YearTableViewCell", for: indexPath) as? YearTableViewCell, let yearText = cell.yearDisplay.text, Int(yearText) != nil {
                    cell.completionLeftButton = {
                        if self.currentDateStatus.year > 1970 && self.currentDateStatus.year < self.currentDateStatus.year + 1 {
                            cell.yearDisplay.text = String(self.currentDateStatus.year - 1)
                            self.currentDateStatus.year -= 1
                            self.dateComponents.year = self.currentDateStatus.year
                            print("\(self.currentDateStatus.year) - \(self.currentDateStatus.month) - \(self.currentDateStatus.dat) - \(self.currentDateStatus.WeekDay)")
                        }
                        else {
                            print("Year index out of Range")
                        }
                        
                        // self.tableView.reloadData()
                        self.tableViewCell.collectionView.reloadData()
                        
                        
                    }
                    cell.completionRightButton = {
                        if self.currentDateStatus.year > 1970 && self.currentDateStatus.year < self.currentDateStatus.year + 1 {
                            cell.yearDisplay.text = String(self.currentDateStatus.year + 1)
                            self.currentDateStatus.year += 1
                            self.dateComponents.year = self.currentDateStatus.year
                            print("\(self.currentDateStatus.year) - \(self.currentDateStatus.month) - \(self.currentDateStatus.dat) - \(self.currentDateStatus.WeekDay)")
                        }
                        else {
                            print("Year Index out of Range")
                        }
                        // self.tableView.reloadData()
                        self.tableViewCell.collectionView.reloadData()
                        self.tableViewCell.collectionView.backgroundColor = UIColor.systemFill
                        
                    }
                    return cell
                } else {
                    return UITableViewCell()
                }
            } else {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MonthTableViewCell", for: indexPath) as? MonthTableViewCell {
                    cell.monthToDisplay.text = self.monthComponents[currentDateStatus.month - 1]
                    cell.completionLeftButton = {
                        var currentMonthIndex = self.currentDateStatus.month - 1
                        if currentMonthIndex > 0 && currentMonthIndex <= 11 {
                            currentMonthIndex -= 1
                            self.currentDateStatus.month -= 1
                            cell.monthToDisplay.text = self.monthComponents[currentMonthIndex]
                            self.dateComponents.month = self.currentDateStatus.month
                            print("\(self.currentDateStatus.year) - \(self.currentDateStatus.month) - \(self.currentDateStatus.dat) - \(self.currentDateStatus.WeekDay)")
                        }
                        else {
                            //                        currentMonthIndex = 11
                            //                        self.currentDateStatus.month = 12
                            //                        cell.monthToDisplay.text = self.monthComponents[currentMonthIndex]
                            //                        self.currentDateStatus.year -= 1
                            
                        }
                        //self.tableView.reloadData()
                        self.tableViewCell.collectionView.reloadData()
                        self.tableViewCell.collectionView.backgroundColor = UIColor.systemFill
                    }
                    cell.completionRightButton = {
                        var currentMonthIndex = self.currentDateStatus.month - 1
                        if currentMonthIndex >= 0 && currentMonthIndex < 11 {
                            currentMonthIndex += 1
                            self.currentDateStatus.month += 1
                            cell.monthToDisplay.text = self.monthComponents[currentMonthIndex]
                            self.dateComponents.month = self.currentDateStatus.month
                            print("\(self.currentDateStatus.year) - \(self.currentDateStatus.month) - \(self.currentDateStatus.dat) - \(self.currentDateStatus.WeekDay)")
                        }
                        else {
                            //                        currentMonthIndex = 0
                            //                        self.currentDateStatus.month = 1
                            //                        cell.monthToDisplay.text = self.monthComponents[currentMonthIndex]
                            //                        self.currentDateStatus.year += 1
                            
                        }
                        //self.tableView.reloadData()
                        self.tableViewCell.collectionView.reloadData()
                        self.tableViewCell.collectionView.backgroundColor = UIColor.systemFill
                    }
                    return cell
                }
                else {
                    return UITableViewCell()
                }
            }
        }
        else {
            if let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as? HeaderTableViewCell {
                cell1.eventLabel.text = eventMessages[indexPath.row]
                return cell1
            }
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 1, let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewCell") as? TableViewCell else {
            return nil
        }
        cell.delegate = self
        self.tableViewCell = cell
        return cell
    }
    
    //
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        do {
            let jsonReminders = try decoder.decode(Reminders.self, from: json)
            self.reminders = jsonReminders.reminderList
            self.tableView.reloadData()
        } catch {
            print(error)
        }
        //
        //        if let jsonReminders = try? decoder.decode(Reminders.self, from: json) {
        //            reminders = jsonReminders.reminderList
        //            //self.tableView.reloadData()
        //        }
        
    }
    
    func parseJSON() {
        if let file = Bundle.main.url(forResource: "Events", withExtension: "json") {
            if let data = try? Data(contentsOf: file) {
                parse(json: data)
                print(self.reminders)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        self.globalDate = Date()
        self.currentDateStatus = dateStatus(today: globalDate)
        let yearNib = UINib.init(nibName: "YearTableViewCell", bundle: nil)
        let monthNib = UINib.init(nibName: "MonthTableViewCell", bundle: nil)
        let dateNib = UINib.init(nibName: "TableViewCell", bundle: nil)
        let eventNib = UINib.init(nibName: "HeaderTableViewCell", bundle: nil)
        self.tableView.register(yearNib, forCellReuseIdentifier: "YearTableViewCell")
        self.tableView.register(monthNib, forCellReuseIdentifier: "MonthTableViewCell")
        self.tableView.register(dateNib, forHeaderFooterViewReuseIdentifier: "TableViewCell")
        self.tableView.register(eventNib, forCellReuseIdentifier: "HeaderTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.reloadData()
    }
}

