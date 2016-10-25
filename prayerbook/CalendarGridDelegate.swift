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
    case mainApp=0, todayExtension
}

class CalendarGridDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cal: Calendar = {
        let c = Calendar.current
        return c
    }()

    var currentDate: Date! {
        didSet {
            let monthStart = Date(1, currentDate.month, currentDate.year)
            cal.locale = Locale(identifier: (Translate.language == "en") ? "en" : "zh_CN")
            startGap = (monthStart.weekday < cal.firstWeekday) ? 7 - (cal.firstWeekday-monthStart.weekday) : monthStart.weekday - cal.firstWeekday
        }
    }
    
    var formatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()
    
    var startGap: Int!
    var containerType : CalendarContainerType!
    var selectedDate: Date?

    override init() {
        super.init()
    }

    @objc func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (currentDate == nil) {
            return 0
        }
        
        let range = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: currentDate)
        return range.length + startGap
    }

    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarViewTextCell
        
        cell.contentView.backgroundColor =  UIColor.clear

        if (indexPath as NSIndexPath).row < startGap {
            cell.dateLabel.text = ""
            return cell
        }
        
        let dayIndex = (indexPath as NSIndexPath).row + 1 - startGap
        let curDate = Date(dayIndex, currentDate.month, currentDate.year)

        cell.dateLabel.text = String(format: "%d", dayIndex)
        cell.dateLabel.textColor = (Cal.isGreatFeast(curDate)) ? UIColor.red : UIColor.black

        if curDate == selectedDate {
            cell.contentView.backgroundColor = UIColor(hex:"#FF8C00")

        } else {
            switch Cal.getFastingDescription(curDate).0 {
            case .vegetarian:
                cell.contentView.backgroundColor = UIColor(hex:"#30D5C8")
                break
                
            case .fishAllowed:
                cell.contentView.backgroundColor = UIColor(hex:"#FADFAD")
                break
                
            case .cheesefare, .fastFree:
                cell.contentView.backgroundColor = UIColor(hex:"#00BFFF")
                break
                
            default:
                let textColor = (containerType == .mainApp) ? UIColor.black : UIColor.white
                cell.dateLabel.textColor = (Cal.isGreatFeast(curDate)) ? UIColor.red : textColor
                break
            }
        }
        
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width) / 7.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func generateLabels(_ view: UIView) {
        formatter.locale = Locale(identifier: (Translate.language == "en") ? "en" : "zh_CN")
        cal.locale = Locale(identifier: (Translate.language == "en") ? "en" : "zh_CN")

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
