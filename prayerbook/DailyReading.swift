//
//  DailyReading.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 03.12.14.
//  Copyright (c) 2014 Alexey Smirnov. All rights reserved.
//

import UIKit

struct DailyReading {
    
    struct LukeSpringParams {
        var PAPSunday : Date!
        var pentecostPrevYear : Date!
        var sundayAfterExaltationPrevYear : Date!
        var totalOffset : Int!
    }
    
    static var LS = LukeSpringParams()
    
    static let specialReadings : [NameOfDay: String] = [
        .nativityOfTheotokos:       "Luke 1:39-49,56 Phil 2:5-11 Luke 10:38-42,11:27-28",
        .exaltationOfCross:         "John 12:28-36 1Cor 1:18-24 John 19:6-11,13-20,25-28,30-35",
        .veilOfTheotokos:           "Luke 1:39-49,56 Heb 9:1-7 Luke 10:38-42,11:27-28",
        .entryIntoTemple:           "Luke 1:39-49,56 Heb 9:1-7 Luke 10:38-42,11:27-28",
        .nativityOfGod:             "Matthew 1:18-25 Gal 4:4-7 Matthew 2:1-12",
        .circumcision:              "John 10:1-9 Col 2:8-12 Luke 2:20-21,40-52",
        .theophany:                 "Mark 1:9-11 Tit 2:11-14,3:4-7 Matthew 3:13-17",
        .meetingOfLord:             "Luke 2:25-32 Heb 7:7-17 Luke 2:22-40",
        .annunciation:              "Luke 1:39-49,56 Heb 2:11-18 Luke 1:24-38",
        .nativityOfJohn:            "Luke 1:24-25,57-68,76,80 Rom 13:12-14:4 Luke 1:5-25,57-68,76,80",
        .peterAndPaul:              "1Cor 4:9-16 Mark 3:13-19",
        .transfiguration:           "Luke 9:28-36 2Pet 1:10-19 Matthew 17:1-9",
        .dormition:                 "Luke 1:39-49,56 Phil 2:5-11 Luke 10:38-42,11:27-28",
        .beheadingOfJohn:           "Matthew 14:1-13 Acts 13:25-32 Mark 6:14-30",

        .saturdayBeforeExaltation:  "1Cor 2:6-9 Matthew 10:37-11:1 # Saturday before the Universal Elevation",
        .sundayBeforeExaltation:    "Gal 6:11-18 John 3:13-17 # Sunday before the Universal Elevation",
        .saturdayAfterExaltation:   "1Cor 1:26-29 John 8:21-30 # Saturday after the Universal Elevation",
        .sundayAfterExaltation:     "Gal 2:16-20 Mark 8:34-9:1 # Sunday after the Universal Elevation",
        .saturdayBeforeNativity:    "Gal 3:8-12 Luke 13:18-29 # Saturday before the Nativity of Christ",
        .sundayBeforeNativity:      "Heb 11:9-10,17-23,32-40 Matthew 1:1-25 # Sunday before Nativity",
        .eveOfNativityOfGod:        "Heb 1:1-12 Luke 2:1-20|Gal 3:15-22 Matthew 13:31-36",
        .saturdayAfterNativity:     "1Tim 6:11-16 Matthew 12:15-21 # Saturday after the Nativity of Christ",
        .sundayAfterNativity:       "Gal 1:11-19 Matthew 2:13-23 # Sunday after Nativity",
        .saturdayBeforeTheophany:   "1Tim 3:14-4:5 Matthew 3:1-11 # Saturday before Theophany",
        .sundayBeforeTheophany:     "2Tim 4:5-8 Mark 1:1-8 # Sunday before Theophany",
        .eveOfTheophany:            "1Cor 9:19-27 Luke 3:1-18",
        .saturdayAfterTheophany:    "Ephes 6:10-17 Matthew 4:1-11 # Saturday after Theophany",
        .sundayAfterTheophany:      "Ephes 4:7-13 Matthew 4:12-17 # Sunday after Theophany",
        .newMartyrsConfessorsOfRussia: "Rom 8:28-39 Luke 21:8-19 # Martyrs",
    ]
    
    static let dontTransferReading : [NameOfDay] = [.newMartyrsConfessorsOfRussia,
        .sundayBeforeNativity, .saturdayBeforeNativity, .eveOfNativityOfGod, .nativityOfGod, .sundayAfterNativity, .saturdayAfterNativity,
        .circumcision,
        .sundayBeforeTheophany, .saturdayBeforeTheophany, .eveOfTheophany, .theophany, .sundayAfterTheophany, .saturdayAfterTheophany,
        .saturdayBeforeExaltation, .sundayBeforeExaltation, .saturdayAfterExaltation, .sundayAfterExaltation
    ]

    static let specialAndRegular: [NameOfDay] = [.saturdayBeforeNativity, .saturdayAfterNativity, .saturdayBeforeTheophany, .saturdayAfterTheophany,
        .saturdayBeforeExaltation,  .saturdayAfterExaltation]
    
    static var vigils = [Date:String]()
    
    static func GospelOfLent(_ date: Date) -> String {
        let bundle = Bundle.main.path(forResource: "ReadingLent", ofType: "plist")
        let readings = NSArray(contentsOfFile: bundle!) as! [String]

        let dayNum = Cal.d(.sundayOfPublicianAndPharisee) >> date;
        return readings[dayNum]
    }
    
    static func GospelOfJohn(_ date: Date) -> String {
        let bundle = Bundle.main.path(forResource: "ReadingJohn", ofType: "plist")
        let readings = NSArray(contentsOfFile: bundle!) as! [String]
        
        let dayNum = Cal.d(.pascha) >> date;
        return readings[dayNum]
    }
    
    static func GospelOfMatthew(_ date: Date) -> String {
        let bundleApostle = Bundle.main.path(forResource: "ReadingApostle", ofType: "plist")
        let apostle = NSArray(contentsOfFile: bundleApostle!) as! [String]

        let bundleMatthew = Bundle.main.path(forResource: "ReadingMatthew", ofType: "plist")
        let gospel = NSArray(contentsOfFile: bundleMatthew!) as! [String]

        var dayNum = (Cal.d(.pentecost)+1.days) >> date;
        var readings = apostle[dayNum] + " "
        
        if dayNum >= 17*7 {
            NSLog("matt exceeding 17 weeks by \(dayNum-17*7+1) days")
            dayNum = dayNum - 7*7
        }
        
        readings += gospel[dayNum]
        return readings
    }
    
    static func initLukeSpring() {
        LS.PAPSunday = Cal.d(.sundayOfPublicianAndPharisee)
        LS.pentecostPrevYear = Cal.paschaDay(Cal.currentYear-1) + 50.days
        
        let exaltationPrevYear = Date(27, 9, Cal.currentYear-1)
        let exaltationPrevYearWeekday = DateComponents(date: exaltationPrevYear).weekday!
        LS.sundayAfterExaltationPrevYear = exaltationPrevYear + (8-exaltationPrevYearWeekday).days

        let endOfLukeReadings = LS.sundayAfterExaltationPrevYear+112.days
        LS.totalOffset = endOfLukeReadings >> LS.PAPSunday
    }
    
    static func GospelOfLukeSpring(_ date: Date) -> String {
        let bundleApostle = Bundle.main.path(forResource: "ReadingApostle", ofType: "plist")
        let apostle = NSArray(contentsOfFile: bundleApostle!) as! [String]
        
        let bundleLuke = Bundle.main.path(forResource: "ReadingLuke", ofType: "plist")
        let gospelLuke = NSArray(contentsOfFile: bundleLuke!) as! [String]

        let bundleMatthew = Bundle.main.path(forResource: "ReadingMatthew", ofType: "plist")
        let gospelMatthew = NSArray(contentsOfFile: bundleMatthew!) as! [String]

        var gospelIndex:Int, apostleIndex:Int
        
        let daysFromPentecost = LS.pentecostPrevYear >> date
        let daysFromExaltation = (LS.sundayAfterExaltationPrevYear+1.days) >> date
        let daysBeforePAP = date >> LS.PAPSunday
        
        if daysFromExaltation >= 16*7-1 {

            // need more than three additional Sundays, use 17th week Matthew readings
            if LS.totalOffset > 28 {
                if daysBeforePAP < 21 && daysBeforePAP >= 14 {
                    let indexMatthew = 118 - (daysBeforePAP-14)
                    return apostle[indexMatthew] + " " + gospelMatthew[indexMatthew]

                } else if daysBeforePAP >= 21 {
                    gospelIndex = 118 - daysBeforePAP
                    apostleIndex = 237 - daysBeforePAP
                    return apostle[apostleIndex] + " " + gospelLuke[gospelIndex]
                }
            }
            
            gospelIndex = 111 - daysBeforePAP
            apostleIndex = 230 - daysBeforePAP
            
        } else if daysFromPentecost >= 33*7-1 {
            gospelIndex = daysFromExaltation
            apostleIndex = 230 - daysBeforePAP

        } else {
            gospelIndex = daysFromExaltation
            apostleIndex = daysFromPentecost
        }
        
        return apostle[apostleIndex] + " " + gospelLuke[gospelIndex]
    }

    static func GospelOfLukeFall(_ date: Date) -> String {
        let bundleApostle = Bundle.main.path(forResource: "ReadingApostle", ofType: "plist")
        let apostle = NSArray(contentsOfFile: bundleApostle!) as! [String]
        
        let bundleLuke = Bundle.main.path(forResource: "ReadingLuke", ofType: "plist")
        let gospel = NSArray(contentsOfFile: bundleLuke!) as! [String]

        // Sunday of Forefathers: Epistle (29th Sunday), Gospel (28th Sunday)
        if (date == Cal.d(.sundayOfForefathers)) {
            return apostle[202] + " " + gospel[76]
        }
        
        var daysFromPentecost = (Cal.d(.pentecost)+1.days) >> date
        var daysFromLukeStart = (Cal.d(.sundayAfterExaltation)+1.days) >> date

        // On 29th Sunday borrow Epistle from Sunday of Forefathers
        if (daysFromPentecost == 202) {
            daysFromPentecost = (Cal.d(.pentecost)+1.days) >> Cal.d(.sundayOfForefathers)
        }
        
        // On 28th Sunday borrow Gospel from Sunday of Forefathers
        if (daysFromLukeStart == 76) {
            daysFromLukeStart = (Cal.d(.sundayAfterExaltation)+1.days) >> Cal.d(.sundayOfForefathers)
        }
        
        return apostle[daysFromPentecost] + " " + gospel[daysFromLukeStart]
    }
    
    static func getRegularReading(_ date: Date) -> String? {
        let exaltation = Date(27, 9, Cal.currentYear)
        let exaltationWeekday = DateComponents(date: exaltation).weekday!
        let exaltationFriOffset = (exaltationWeekday >= 6) ? 13-exaltationWeekday : 6-exaltationWeekday
        let fridayAfterExaltation = exaltation + exaltationFriOffset.days
        
        switch (date) {
        case Cal.d(.startOfYear) ..< Cal.d(.sundayOfPublicianAndPharisee):
            return GospelOfLukeSpring(date)
            
        case Cal.d(.sundayOfPublicianAndPharisee) ..< Cal.d(.pascha):
            let reading = GospelOfLent(date)
            return reading.characters.count > 0 ? reading : nil
            
        case Cal.d(.pascha) ... Cal.d(.pentecost):
            return GospelOfJohn(date)
            
        case Cal.d(.pentecost)+1.days ... fridayAfterExaltation:
            return GospelOfMatthew(date)
            
        case Cal.d(.sundayAfterExaltation)+1.days ... Cal.d(.endOfYear):
            return GospelOfLukeFall(date)
            
        default: return nil
        }
    }

    static func transferReading(_ date: Date) -> Date? {
        let weekday = DayOfWeek(rawValue: DateComponents(date:date).weekday!)
        var newDate:Date

        if Cal.d(.beginningOfGreatLent) ... Cal.d(.pascha) ~= date {
            return nil
        }

        if  Cal.d(.pascha)...Cal.d(.pentecost) ~= date {
            return date
        }
        
        if weekday == .sunday {
            return nil
            
        } else if weekday == .monday {
            newDate = date + 1.days
            
            if let _ = vigils[newDate] {
                return date
            }
            
        } else {
            newDate = date - 1.days
            if let _ = vigils[newDate] {
                return date + 1.days
            }
        }
        
        return newDate
    }
    
    static func getDailyReading(_ date: Date) -> [String] {
        var readings = [String]()
        var transferred = [Date:String]()
        var noRegularReading = false
        var sundayBeforeNativity = false
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "cccc"
        formatter.locale = Locale(identifier: "en")
        
        Cal.setDate(date)
        initLukeSpring()
        
        vigils = [
            Date(30, 1, Cal.currentYear):     "Heb 13:17-21 Luke 6:17-23 # Venerable Anthony",
            Date(2, 2, Cal.currentYear):      "Heb 13:17-21 Luke 6:17-23 # Venerable Euthymius",
            Date(12, 2, Cal.currentYear):     "Heb 13:7-16 Matthew 5:14-19 # Hierarchs",
            Date(6, 5, Cal.currentYear):      "Acts 12:1-11 John 15:17-16:2 # St. George",
            Date(21, 5, Cal.currentYear):     "1John 1:1-7 John 19:25-27,21:24-25 # Apostle",
            Date(24, 5, Cal.currentYear):     "Heb 7:26-8:2 Matthew 5:14-19 # Equal-to-the Apostles",
            Date(28, 7, Cal.currentYear):     "Gal 1:11-19 John 10:1-9 # Equal-to-the Apostles",
            Date(1, 8, Cal.currentYear):      "Gal 5:22-6:2 Luke 6:17-23 # Saint",
            Date(2, 8, Cal.currentYear):      "James 5:10-20 Luke 4:22-30 # Prophet",
            Date(14, 9, Cal.currentYear):     "1Tim 2:1-7 Luke 4:16-22 # New Year",
            Date(9, 10, Cal.currentYear):     "1John 4:12-19 John 19:25-27,21:24-25 # Repose of the John the Theologian",
            Date(26, 11, Cal.currentYear):    "Heb 7:26-8:2 John 10:9-16 # St. John",
            Date(18, 12, Cal.currentYear):    "Gal 5:22-6:2 Matthew 11:27-30 # Saint",
            Date(19, 12, Cal.currentYear):    "Heb 13:17-21 Luke 6:17-23 # St. Nicholas",
        ]
        
        for code in Array(specialReadings.keys) where !dontTransferReading.contains(code) {
            if let newDate = transferReading(Cal.d(code))  {
                let oldDate = Cal.d(code)
                let comment = (newDate == oldDate) ? "" : String(format: "# %@ Reading", formatter.string(from: oldDate))
                transferred[newDate] =  String(format: "%@ %@", getRegularReading(oldDate)!, comment)
            }
        }
        
        for (vigilDate, _) in vigils {
            if let newDate = transferReading(vigilDate) {
                let comment = (newDate == vigilDate) ? "" : String(format: "# %@ Reading", formatter.string(from: vigilDate))
                transferred[newDate] = String(format: "%@ %@", getRegularReading(vigilDate)!, comment)
            }
        }
        
        for code in Cal.feastDates[date] ?? [] {
            if code == .sundayBeforeNativity {
                sundayBeforeNativity = true
            }
            
            if Array(specialReadings.keys).contains(code) {
                noRegularReading = true
                
                if (code == .eveOfNativityOfGod) {
                    let choices = specialReadings[code]!.components(separatedBy: "|")
                    let weekday = DateComponents(date:date).weekday
                    readings.append((weekday == 7 || weekday == 1) ? choices[1] : choices[0])
                    
                } else {
                    readings += [specialReadings[code]!]
                    
                }
            }
        }

        let synaxisTheotokos = Cal.d(.synaxisTheotokos)
        let synaxisWeekday = DayOfWeek(rawValue: synaxisTheotokos.weekday)
        
        if date == synaxisTheotokos {
            if synaxisWeekday == .monday {
                return ["Heb 2:11-18 # Theotokos", "Gal 1:11-19 Matthew 2:13-23 # Holy Ancestors"]
                
            } else if synaxisWeekday != .sunday {
                return ["Heb 2:11-18 Matthew 2:13-23 # Theotokos"]
            }
        }
        
        if date == Cal.d(.sundayAfterNativity) {
            let daysFromExaltation = (LS.sundayAfterExaltationPrevYear+1.days) >> date
            
            if (111-daysFromExaltation >= LS.totalOffset) {
                noRegularReading = false
            }
                        
        } else if Cal.currentWeekday == .sunday && !sundayBeforeNativity && !(Cal.d(.beginningOfGreatLent) ... Cal.d(.pascha) ~= date) {
            noRegularReading = false
        }
        
        for code in Cal.feastDates[date] ?? [] where specialAndRegular.contains(code) {
            noRegularReading = false
            break
        }
        
        if (noRegularReading) {
            return readings
        }
        
        if let vigilReading = vigils[date] {
            readings += [vigilReading]

            if Cal.currentWeekday != .sunday {
                return readings + (transferred[date].map { [$0] } ?? [])
            }
        }

        return readings + (getRegularReading(date).map { [$0] } ?? []) + (transferred[date].map { [$0] } ?? [])

    }
        
}
