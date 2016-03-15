//
//  CalendarGridViewController.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 12/15/15.
//  Copyright © 2015 Alexey Smirnov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CalendarTextCell"

enum CalendarContainerType: Int {
    case MainApp=0, TodayExtension
}

class CalendarGridDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let prefs = NSUserDefaults(suiteName: groupId)!

    let cal: NSCalendar = {
        let c = NSCalendar.currentCalendar()
        return c
    }()

    var currentDate: NSDate! {
        didSet {
            let monthStart = NSDate(1, currentDate.month, currentDate.year)
            cal.locale = NSLocale(localeIdentifier: "ru")
            startGap = (monthStart.weekday < cal.firstWeekday) ? 7 - (cal.firstWeekday-monthStart.weekday) : monthStart.weekday - cal.firstWeekday
        }
    }
    
    var formatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()
    
    var startGap: Int!
    var containerType : CalendarContainerType!
    var selectedDate: NSDate?

    override init() {
        super.init()
    }

    @objc func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (currentDate == nil) {
            return 0
        }
        
        let range = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: currentDate)
        return range.length + startGap
    }

    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CalendarViewTextCell
        
        cell.contentView.backgroundColor =  UIColor.clearColor()

        if indexPath.row < startGap {
            cell.dateLabel.text = ""
            return cell
        }
        
        let dayIndex = indexPath.row + 1 - startGap
        let curDate = NSDate(dayIndex, currentDate.month, currentDate.year)

        cell.dateLabel.text = String(format: "%d", dayIndex)
        cell.dateLabel.textColor = (Cal.isGreatFeast(curDate)) ? UIColor.redColor() : UIColor.blackColor()

        if curDate == selectedDate {
            cell.contentView.backgroundColor = UIColor(hex:"#FF8C00")

        } else {
            
            let (fastType, _) = Cal.getFastingDescription(curDate, FastingLevel(rawValue: prefs.integerForKey("fastingLevel"))!)
            
            if fastType == .NoFast || fastType == .NoFastMonastic {
                let textColor = (containerType == .MainApp) ? UIColor.blackColor() : UIColor.whiteColor()
                cell.dateLabel.textColor = (Cal.isGreatFeast(curDate)) ? UIColor.redColor() : textColor

            } else {
                cell.contentView.backgroundColor = UIColor(hex:Cal.fastingColor[fastType]!)
            }
            
        }
        
        return cell
    }
    
    @objc func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width) / 7.0
        return CGSizeMake(cellWidth, cellWidth)
    }
    
    func generateLabels(view: UIView) {
        formatter.locale = NSLocale(localeIdentifier: "ru")
        cal.locale = NSLocale(localeIdentifier: "ru")

        let dayLabel = formatter.veryShortWeekdaySymbols as [String]
        
        for index in cal.firstWeekday...7 {
            if let label = view.viewWithTag(index-cal.firstWeekday+1) as? UILabel {
                label.text = dayLabel[index-1]
            }
        }
        
        if cal.firstWeekday > 1 {
            for index in 1...cal.firstWeekday-1 {
                if let label = view.viewWithTag(8-cal.firstWeekday+index) as? UILabel {
                    label.text = dayLabel[index-1]
                }
            }
        }

    }
    

}
