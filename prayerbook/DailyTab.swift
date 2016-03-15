//
//  DailyTab.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 27.03.15.
//  Copyright (c) 2015 Alexey Smirnov. All rights reserved.
//

import UIKit
import Squeal

class DailyTab: UITableViewController, NAModalSheetDelegate {

    let prefs = NSUserDefaults(suiteName: groupId)!

    var fasting: (FastingType, String) = (.Vegetarian, "")
    var fastingLevel: FastingLevel = .Monastic
    
    var foodIcon: [FastingType: String] = [
        .NoFast:        "meat",
        .Vegetarian:    "vegetables",
        .FishAllowed:   "fish",
        .FastFree:      "cupcake",
        .Cheesefare:    "cheese",
        .NoFood:        "nothing",
        .Xerography:    "xerography",
        .WithoutOil:    "without-oil",
        .NoFastMonastic:"pizza"
    ]
    
    var readings = [String]()
    var dayDescription = [(FeastType, String)]()
    var saints = [(FeastType, String)]()

    var currentDate: NSDate = {
        // this is done to remove time component from date
        return NSDateComponents(date: NSDate()).toDate()
    }()
    
    var formatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateFormat = "cccc d MMMM yyyy г."
        return formatter
    }()

    var formatterOldStyle: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateFormat = "d MMMM yyyy г. (ст. ст.)"
        return formatter
    }()

    var modal: NAModalSheet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtons()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: optionsSavedNotification, object: nil)

        reload()
    }

    func hasTypica() -> Bool {        
        if (currentDate > Cal.d(.BeginningOfGreatLent) && currentDate < Cal.d(.Sunday2AfterPascha) ||
            Cal.currentWeekday != .Sunday) {
            return false

        } else {
            return true
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dayDescription.count+2
        case 1:
            return 1
        case 2:
            return readings.count
        case 3:
            return hasTypica() ? 1 : 0
        case 4:
            return saints.count
            
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""

        case 1:
            return (fastingLevel == .Monastic) ? Translate.s("Monastic fasting") : Translate.s("Laymen fasting")
        case 2:
            return readings.count > 0 ? Translate.s("Gospel of the day") : nil

        case 3:
            return hasTypica() ? Translate.s("Prayers") : nil

        case 4:
            return Translate.s("Memory of saints")
            
        default:
            return ""
        }
    }

    func getCell<T: ConfigurableCell>() -> T {
        if let newCell  = tableView.dequeueReusableCellWithIdentifier(T.cellId) as? T {
            newCell.accessoryType = .None
            return newCell
            
        } else {
            return T(style: UITableViewCellStyle.Default, reuseIdentifier: T.cellId)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell: TextDetailsCell = getCell()
                cell.title.text = formatter.stringFromDate(currentDate)
                cell.subtitle.text = formatterOldStyle.stringFromDate(currentDate-13.days)
                return cell

            case 1:
                let cell: TextCell = getCell()
                var descr = ""
                
                if let weekDescription = Cal.getWeekDescription(currentDate) {
                    descr = weekDescription
                }
                
                if let toneDescription = Cal.getToneDescription(currentDate) {
                    if descr.characters.count > 0 {
                        descr += "; "
                    }
                    descr += toneDescription
                }

                cell.title.textColor =  UIColor.blackColor()
                cell.title.text = descr
                return cell
                
            default:
                let feast:FeastType = dayDescription[indexPath.row-2].0

                if feast == .None {
                    let cell: TextCell = getCell()
                    cell.title.textColor =  UIColor.blackColor()
                    cell.title.text = dayDescription[indexPath.row-2].1
                    return cell
                    
                } else if feast == .Great {
                    let cell: ImageCell = getCell()
                    cell.title.textColor = UIColor.redColor()
                    cell.title.text = dayDescription[indexPath.row-2].1
                    cell.icon.image = UIImage(named: Cal.feastIcon[feast]!)
                    return cell
                    
                } else {
                    let cell: TextCell = getCell()
                    let image = UIImage(named: Cal.feastIcon[feast]!)!
                    
                    let attachment = NSTextAttachment()
                    attachment.image = image.resize(CGSizeMake(15, 15))
                    
                    let myString = NSMutableAttributedString(string: "")
                    myString.appendAttributedString(NSAttributedString(attachment: attachment))
                    myString.appendAttributedString(NSMutableAttributedString(string: dayDescription[indexPath.row-2].1))
                    cell.title.attributedText = myString
                    
                    return cell
                }
            }
        
        } else if indexPath.section == 1 {
            let cell: ImageCell  = getCell()
            cell.title.text = fasting.1
            cell.title.textColor =  UIColor.blackColor()
            cell.icon.image = UIImage(named: "food-\(foodIcon[fasting.0]!)")
            cell.accessoryType = (fastingLevel == .Monastic) ?  .None : .DisclosureIndicator
            return cell

        } else if indexPath.section == 2 {
            let cell: TextDetailsCell = getCell()
            cell.title.textColor = UIColor.blackColor()
            cell.title.text = Translate.readings(readings[indexPath.row])
            cell.subtitle.text = ""
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        } else if indexPath.section == 3 {
            let cell: TextDetailsCell = getCell()
            cell.title.textColor = UIColor.blackColor()
            cell.title.text = Translate.s("Typica")
            cell.subtitle.text = ""
            cell.accessoryType = .DisclosureIndicator
            return cell

        } else if indexPath.section == 4 {
            if saints[indexPath.row].0 == .None {
                let cell: TextCell = getCell()
                cell.title.textColor =  UIColor.blackColor()
                cell.title.text = saints[indexPath.row].1
                return cell

            } else {
                let cell: TextCell = getCell()
                let image = UIImage(named: Cal.feastIcon[saints[indexPath.row].0]!)!
                
                let attachment = NSTextAttachment()
                attachment.image = image.resize(CGSizeMake(15, 15))
                let attachmentString = NSAttributedString(attachment: attachment)
                
                let myString = NSMutableAttributedString(string: "")
                myString.appendAttributedString(attachmentString)
                myString.appendAttributedString(NSMutableAttributedString(string: saints[indexPath.row].1))
                cell.title.attributedText = myString
                
                return cell

            }
        }
        
        let cell: TextCell = getCell()
        return cell

    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 2 && readings.count > 0 {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("Scripture") as! Scripture
            vc.code = .Pericope(readings[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)

        } else if fastingLevel == .Laymen && indexPath.section == 1 && indexPath.row == 0 {
            let fastingInfo = FastingViewController(nibName: "FastingViewController", bundle: nil)
            let modal = NAModalSheet(viewController: fastingInfo, presentationStyle: .FadeInCentered)
            
            modal.disableBlurredBackground = true
            modal.cornerRadiusWhenCentered = 10
            modal.delegate = self
            
            fastingInfo.modal = modal
            fastingInfo.type =  fasting.0
            fastingInfo.fastTitle = fasting.1
            
            modal.presentWithCompletion({})

        } else if indexPath.section == 3 {
            let prayer = storyboard!.instantiateViewControllerWithIdentifier("Prayer") as! Prayer
            prayer.code = "typica"
            prayer.index = 0
            prayer.name = Translate.s("Typica")
            navigationController?.pushViewController(prayer, animated: true)

        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell : UITableViewCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return calculateHeightForCell(cell)
    }

    func calculateHeightForCell(cell: UITableViewCell) -> CGFloat {
        cell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(cell.bounds))
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height+1.0
    }

    // MARK: private stuff
    
    func reload() {
        formatter.locale = Translate.locale
        formatterOldStyle.locale = Translate.locale

        dayDescription = Cal.getDayDescription(currentDate)
        readings = DailyReading.getDailyReading(currentDate)
        fastingLevel = FastingLevel(rawValue: prefs.integerForKey("fastingLevel"))!
        fasting = Cal.getFastingDescription(currentDate, fastingLevel)
        saints=Db.saints(currentDate)

        tableView.reloadData()
    }

    func addBarButtons() {
        let button_calendar = UIBarButtonItem(image: UIImage(named: "calendar"), style: .Plain, target: self, action: "showCalendar")
        let button_left = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .Plain, target: self, action: "prevDay")
        let button_right = UIBarButtonItem(image: UIImage(named: "arrow-right"), style: .Plain, target: self, action: "nextDay")
        
        let button_widget = UIBarButtonItem(image: UIImage(named: "widget"), style: .Plain, target: self, action: "showTutorial")
        let button_options = UIBarButtonItem(image: UIImage(named: "options"), style: .Plain, target: self, action: "showOptions")

        button_calendar.imageInsets = UIEdgeInsetsMake(0,0,0,-20)
        button_left.imageInsets = UIEdgeInsetsMake(0,0,0,-20)
        button_widget.imageInsets = UIEdgeInsetsMake(0,0,0,-20)
        
        navigationItem.leftBarButtonItems = [button_calendar, button_left, button_right]
        navigationItem.rightBarButtonItems = [button_options, button_widget]
    }

    func prevDay() {
        currentDate = currentDate - 1.days;
        reload()
    }
    
    func nextDay() {
        currentDate = currentDate + 1.days;
        reload()
    }
    
    func showCalendar() {
        var width, height : CGFloat
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            width = 300
            height = 350

        } else {
            width = 500
            height = 500
        }

        let container = storyboard!.instantiateViewControllerWithIdentifier("CalendarContainer") as! UINavigationController
        container.view.frame = CGRectMake(0, 0, width, height)
        
        modal = NAModalSheet(viewController: container, presentationStyle: .FadeInCentered)
        
        modal.disableBlurredBackground = true
        modal.cornerRadiusWhenCentered = 10
        modal.delegate = self
        modal.adjustContentSize(CGSizeMake(width, height), animated: false)
        
        (container.topViewController as! CalendarContainer).delegate = self

        modal.presentWithCompletion({})
    }
    
    func updateDate(date: NSDate?) {
        if let newDate = date {
            currentDate = newDate
            reload()
        }
        
        modal.dismissWithCompletion({  })
    }
    
    func showTutorial() {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("Tutorial") as! Tutorial
        let nav = UINavigationController(rootViewController: vc)
        vc.delegate = self
        
        navigationController?.presentViewController(nav, animated: true, completion: {})
    }

    func showOptions() {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("Options") as! Options
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.presentViewController(nav, animated: true, completion: {})
    }    
    
    // MARK: NAModalSheetDelegate
    
    func modalSheetTouchedOutsideContent(sheet: NAModalSheet!) {
        sheet.dismissWithCompletion({})
    }
    
    func modalSheetShouldAutorotate(sheet: NAModalSheet!) -> Bool {
        return shouldAutorotate()
    }
    
    func modalSheetSupportedInterfaceOrientations(sheet: NAModalSheet!) -> UInt {
        return supportedInterfaceOrientations().rawValue
    }

}