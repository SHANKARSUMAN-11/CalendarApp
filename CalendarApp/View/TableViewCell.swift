//
//  TableViewCell.swift
//  CalendarApp
//
//  Created by Shankar Suman on 01/03/20.
//  Copyright © 2020 Shankar Suman. All rights reserved.
//

import UIKit
import Foundation



class TableViewCell: UITableViewHeaderFooterView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var currentDate = Date()
    
    //let noOfSecondsInDay = 86400
    
    var delegate: DateProtocol?
    
    
    func dateFromDateSpecs(dateGiven: (year: Int, month: Int, dat: Int)) -> Date {
     var dateComponents = DateComponents()
        dateComponents.year = dateGiven.year
        dateComponents.month = dateGiven.month
        dateComponents.day = dateGiven.dat
        
        return Calendar.current.date(from: dateComponents)!
    }
    
      
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - CGFloat(32))/CGFloat(7), height: (UIScreen.main.bounds.width - CGFloat(32))/CGFloat(7))
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.row >= 0 && indexPath.row <= 6 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as? DayCollectionViewCell {
                cell.dayLabel.text = dotw[indexPath.row]
                cell.dayLabel.textColor = UIColor.black
            return cell
            }
            else {
                return DayCollectionViewCell()
            }
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as? DayCollectionViewCell {
                
                let firstDateOfTheMonth = getFirstWeekDayOfMonth(dateFromDateSpecs(dateGiven: delegate!.getDateSpecs()))
                let lastDateOfTheMonth = getLastWeekdayOfMonth(dateFromDateSpecs(dateGiven: delegate!.getDateSpecs()))
                let firstDateStatus = dateStatus(datenow: firstDateOfTheMonth)
                let lastDateStatus = dateStatus(datenow: lastDateOfTheMonth)
                let curDateStatus = dateStatus(datenow: currentDate)
                let difference = lastDateStatus.dat - firstDateStatus.dat
                let firstDateIndex = firstDateStatus.WeekDay + 6
                let lastDateIndex = firstDateIndex + difference
                let currentDateIndex = firstDateIndex + curDateStatus.dat - firstDateStatus.dat
//
//                print("firstDateOfTheMonth: \(firstDateOfTheMonth)")
//                print("lastDateOfTheMonth:\(lastDateOfTheMonth)")
//                print("firstDateStatus:\(firstDateStatus)")
//                print("lastDateStatus:\(lastDateStatus)")
//                print("curDateStatus:\(curDateStatus)")
//                print("difference:\(difference)")
//                print("firstDateIndex:\(firstDateIndex)")
//                print("lastDateIndex:\(lastDateIndex)")
//                print("currentDateIndex:\(currentDateIndex)")
//                if indexPath.item == currentDateIndex {
//                    //cell.dayLabel.isHighlighted = true
//                    //cell.dayLabel.backgroundColor = UIColor.red
//
//                }
                if indexPath.item == currentDateIndex {
                    cell.dayLabel.isHighlighted = true
                    cell.dayLabel.highlightedTextColor = UIColor.red
                    cell.dayLabel.isHighlighted = !cell.dayLabel.isHighlighted
                    
                }
                if indexPath.item < firstDateIndex {
                    let diff = firstDateIndex - indexPath.item
                    var currDay = firstDateOfTheMonth
                    for _ in (1...diff) {
                     currDay = yesterday(now: currDay)
                    }
                    let firstDate = String(dateStatus(datenow: currDay).dat)
                    cell.dayLabel.text = firstDate
                    cell.dayLabel.textColor = UIColor.systemGray
                } else if (indexPath.item >= firstDateIndex && indexPath.item <= lastDateIndex) {
                    cell.dayLabel.text = String(indexPath.item - firstDateIndex + 1)
                    cell.dayLabel.textColor = UIColor.black
                } else {
                    cell.dayLabel.text = String(indexPath.item - lastDateStatus.dat - (firstDateIndex - 1))
                    cell.dayLabel.textColor = UIColor.gray
                    //cell.dayLabel.setTitleColor(UIColor.gray, for: .normal)
                }
               return cell
            }
            else {
                return DayCollectionViewCell()
            }
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       var cellText: Int = 0
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell {
            cellText = Int(cell.dayLabel.text ?? "76") ?? 66
            delegate!.getEvents(pressedYear: delegate!.getDateSpecs().year, pressedMonth: delegate!.getDateSpecs().month, pressedDay: cellText)
        } else {
           print("Sorry")
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    let dotw : [String] = ["S", "M", "T", "W", "T", "F", "S"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let colnib = UINib.init(nibName: "DayCollectionViewCell", bundle: nil)
        self.collectionView.register(colnib, forCellWithReuseIdentifier:
            "DayCollectionViewCell")

        //let curDateStatus = getcurrentDate()
        //let currentDayOfTheMonth = dotw[curDateStatus.weekday - 1]
        
        
    }

    
    func getcurrentDate() -> (year: Int, month: Int, date: Int, weekday: Int)  {
        let curYear = Calendar.current.component(.year, from: currentDate)
        let curMonth = Calendar.current.component(.month, from: currentDate)
        let curDay = Calendar.current.component(.day, from: currentDate)
        let curWeekDay = Calendar.current.component(.weekday, from: currentDate)
        
        return (curYear, curMonth, curDay, curWeekDay)
        
    }
    func getFirstWeekDayOfMonth(_ date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: components)
        print(date)
        return startOfMonth!

    }
   
    func getLastWeekdayOfMonth(_ date: Date) -> Date {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp)!
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
        print(date)
        return endOfMonth!
    }
    
    func yesterday(now today: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day) // -1 day

        let yesterday = Calendar.current.date(byAdding: dateComponents, to: today) // Add the DateComponents

        return yesterday!
    }
    
    func tomorrow(now today: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day) // -1 day

        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: today) // Add the DateComponents

        return tomorrow!
    }
    
    func dateStatus(datenow: Date) -> (year: Int, month: Int, dat: Int, WeekDay: Int) {
        let year = Calendar.current.component(.year, from: datenow)
        let month = Calendar.current.component(.month, from: datenow)
        let date = Calendar.current.component(.day, from: datenow)
        let weekDay = Calendar.current.component(.weekday, from: datenow)
        
    
        return (year, month,date, weekDay)
    }
    
    
    
}
