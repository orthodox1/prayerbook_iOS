
import UIKit

enum FeastType: Int {
    case None=0, NoSign, SixVerse, Doxology, Polyeleos, Vigil, Great
}

enum NameOfDay: Int {
    case StartOfYear=0, Pascha, Pentecost, Ascension, PalmSunday, EveOfNativityOfGod, NativityOfGod, Circumcision, EveOfTheophany, Theophany, MeetingOfLord, Annunciation, NativityOfJohn, PeterAndPaul, Transfiguration, Dormition, BeheadingOfJohn, NativityOfTheotokos, ExaltationOfCross, VeilOfTheotokos, EntryIntoTemple, StNicholas, SundayOfPublicianAndPharisee, SundayOfProdigalSon, SundayOfDreadJudgement, CheesefareSunday, BeginningOfGreatLent, BeginningOfDormitionFast, BeginningOfNativityFast, BeginningOfApostolesFast, SundayOfForefathers, SundayBeforeNativity, SundayAfterExaltation, SaturdayAfterExaltation, SaturdayBeforeExaltation, SundayBeforeExaltation, SaturdayBeforeNativity, SaturdayAfterNativity, SundayAfterNativity, SaturdayBeforeTheophany, SundayBeforeTheophany, SaturdayAfterTheophany, SundayAfterTheophany, Sunday2AfterPascha, Sunday3AfterPascha, Sunday4AfterPascha, Sunday5AfterPascha, Sunday6AfterPascha, Sunday7AfterPascha, LazarusSaturday, NewMartyrsConfessorsOfRussia, EndOfYear
}

enum FastingType: Int {
    case NoFast=0, Vegetarian, FishAllowed, FastFree, Cheesefare
}

enum DayOfWeek: Int  {
    case Sunday=1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

struct DateCache : Hashable {
    let code : NameOfDay
    let year : Int
    init(_ code: NameOfDay, _ year: Int) {
        self.code = code
        self.year = year
    }
    var hashValue: Int {
        return code.hashValue ^ year.hashValue
    }
}

// MARK: Equatable

func == (lhs: DateCache, rhs: DateCache) -> Bool {
    return lhs.code == rhs.code && lhs.year == rhs.year
}

struct ChurchCalendar {

    static var formatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    static var currentYear: Int!
    static var currentWeekday: DayOfWeek!
    static var feastDates = [NSDate: [NameOfDay]]()
    static var dCache = [DateCache:NSDate]()

    static var dateFeastDescr = [NSDate: [(FeastType, String)]]()
    static let codeFeastDescr : [NameOfDay: [(FeastType, String)]] = [
        .Pascha:                    [(.Great, "PASCHA. The Bright and Glorious Resurrection of our Lord, God, and Saviour Jesus Christ")],
        .Pentecost:                 [(.Great, "Pentecost. Sunday of the Holy Trinity. Descent of the Holy Spirit on the Apostles")],
        .Ascension:                 [(.Great, "Ascension of our Lord, God, and Saviour Jesus Christ")],
        .PalmSunday:                [(.Great, "Palm Sunday. Entrance of our Lord into Jerusalem")],
        .EveOfNativityOfGod:        [(.NoSign, "Eve of the Nativity of Christ")],
        .NativityOfGod:             [(.Great, "The Nativity of our Lord God and Savior Jesus Christ")],
        .Circumcision:              [(.Great, "Circumcision of our Lord")],
        .EveOfTheophany:            [(.NoSign, "Eve of Theophany")],
        .Theophany:                 [(.Great, "Holy Theophany: the Baptism of Our Lord, God, and Saviour Jesus Christ")],
        .MeetingOfLord:             [(.Great, "The Meeting of our Lord, God, and Saviour Jesus Christ in the Temple")],
        .Annunciation:              [(.Great, "The Annunciation of our Most Holy Lady, Theotokos and Ever-Virgin Mary")],
        .NativityOfJohn:            [(.Great, "Nativity of the Holy Glorious Prophet, Forerunner, and Baptist of the Lord, John")],
        .PeterAndPaul:              [(.Great, "The Holy Glorious and All-Praised Leaders of the Apostles, Peter and Paul")],
        .Transfiguration:           [(.Great, "The Holy Transfiguration of Our Lord God and Saviour Jesus Christ")],
        .Dormition:                 [(.Great, "The Dormition (Repose) of our Most Holy Lady Theotokos and Ever-Virgin Mary")],
        .BeheadingOfJohn:           [(.Great, "The Beheading of the Holy Glorious Prophet, Forerunner and Baptist of the Lord, John")],
        .NativityOfTheotokos:       [(.Great, "Nativity of Our Most Holy Lady Theotokos and Ever-Virgin Mary")],
        .ExaltationOfCross:         [(.Great, "The Universal Exaltation of the Precious and Life-Giving Cross")],
        .VeilOfTheotokos:           [(.Great, "Protection of Our Most Holy Lady Theotokos and Ever-Virgin Mary")],
        .EntryIntoTemple:           [(.Great, "Entry into the Temple of our Most Holy Lady Theotokos and Ever-Virgin Mary")],
        .BeginningOfGreatLent:      [(.None, "Beginning of Great Lent")],
        .BeginningOfDormitionFast:  [(.None, "Beginning of Dormition fast")],
        .BeginningOfNativityFast:   [(.None, "Beginning of Nativity fast")],
        .BeginningOfApostolesFast:  [(.None, "Beginning of Apostoles' fast")],
        .SundayOfForefathers:       [(.None, "Sunday of the Holy Forefathers")],
        .SundayAfterExaltation:     [(.None, "Sunday after the Exaltation")],
        .SaturdayAfterExaltation:   [(.None, "Saturday after the Exaltation")],
        .SaturdayBeforeExaltation:  [(.None, "Saturday before the Exaltation")],
        .SundayBeforeExaltation:    [(.None, "Sunday before the Exaltation")],
        .SaturdayBeforeNativity:    [(.None, "Saturday before the Nativity of Christ")],
        .SundayBeforeNativity:      [(.None, "Sunday before the Nativity of Christ, of the Fathers")],
        .SaturdayAfterNativity:     [(.None, "Saturday after the Nativity of Christ")],
        .SundayAfterNativity:       [(.None, "Sunday after Nativity"),
                                     (.NoSign, "Saints Joseph the Betrothed, David the King, and James the Brother of the Lord")],
        .SaturdayBeforeTheophany:   [(.None, "Saturday before Theophany")],
        .SundayBeforeTheophany:     [(.None, "Sunday before Theophany")],
        .SaturdayAfterTheophany:    [(.None, "Saturday after Theophany")],
        .SundayAfterTheophany:      [(.None, "Sunday after Theophany")],
        .NewMartyrsConfessorsOfRussia: [(.Vigil, "Holy New Martyrs and Confessors of Russia")],
    ]

    static let feastIcon : [FeastType: String] = [
        .NoSign: "nosign",
        .SixVerse: "sixverse",
        .Doxology: "doxology",
        .Polyeleos: "polyeleos",
        .Vigil: "vigil",
        .Great: "great"
    ]

    static let greatFeastCodes : [NameOfDay] = [.PalmSunday, .Pascha, .Ascension, .Pentecost, .NativityOfGod, .Circumcision, .Theophany, .MeetingOfLord, .Annunciation, .NativityOfJohn, .PeterAndPaul, .Transfiguration, .Dormition, .BeheadingOfJohn, .NativityOfTheotokos, .ExaltationOfCross, .VeilOfTheotokos, .EntryIntoTemple]

    static func saveFeastDate(code: NameOfDay, _ year:Int) {
        
        if (code == .SundayBeforeNativity || code == .SaturdayBeforeNativity) {
            // it is possible that there will be 2 Sundays or Saturdays before Nativity in a given year
            return;
        }
        
        var res = filter(feastDates, { (date, codes) in
            return contains(codes, code) && NSDateComponents(date:date).year == year
        })
        
        dCache[DateCache(code, year)] = res[0].0
    }
    
    static func d(code: NameOfDay) -> NSDate {
        return dCache[DateCache(code, currentYear)]!
    }
    
    static func setDate(date: NSDate) {
        let dateComponents = NSDateComponents(date: date)
        currentYear = dateComponents.year
        currentWeekday = DayOfWeek(rawValue: dateComponents.weekday)
        
        if dCache[DateCache(.Pascha, currentYear)] == nil {
            generateFeastDates(currentYear)
            generateFeastDescription(currentYear)
        }
    }

    static func paschaDay(year: Int) -> NSDate {
        // http://calendar.lenacom.spb.ru/index.php
        let a = (19*(year%19) + 15) % 30
        let b = (2*(year%4) + 4*(year%7) + 6*a + 6) % 7

        return  ((a+b > 10) ? NSDateComponents(a+b-9, 4, year).toDate() : NSDateComponents(22+a+b, 3, year).toDate()) + 13.days
    }
    
    static func generateFeastDescription(year: Int) {
        let pascha = paschaDay(year)
        let greatLentStart = pascha-48.days
        let pentecost = d(.Pentecost)
        
        var miscFeasts :[NSDate: [(FeastType, String)]] = [
            greatLentStart-2.days:  [(.NoSign, "Commemoration of all the saints, who showed forth in asceticism")],
            greatLentStart+5.days:  [(.NoSign, "Great Martyr Theodore the Recruit († c. 306)")],
            greatLentStart+6.days:  [(.None,   "Triumph of Orthodoxy")],
            greatLentStart+12.days: [(.None,   "Commemoration of the Departed")],
            greatLentStart+13.days: [(.NoSign, "Saint Gregory Palamas, Archbishop of Thessalonica († c. 1360)")],
            greatLentStart+19.days: [(.None,   "Commemoration of the Departed")],
            greatLentStart+20.days: [(.None,   "Veneration of the Precious Cross")],
            greatLentStart+26.days: [(.None,   "Commemoration of the Departed")],
            greatLentStart+27.days: [(.NoSign, "Venerable John Climacus of Sinai, Author of “the Ladder” († 649)")],
            greatLentStart+33.days: [(.None,   "Saturday of the Akathist; Laudation of the Most Holy Theotokos")],
            greatLentStart+34.days: [(.None,   "Venerable Mary of Egypt")],
            pascha+5.days:          [(.None,   "Feast of the Life-Giving Spring of the Mother of God")],
            pascha+9.days:          [(.None,   "Radonitsa (Day of Rejoycing)")],
            pascha+14.days:         [(.NoSign, "St Joseph of Arimathea, and Nicodemus"),
                                     (.NoSign, "Right-believing Tamara, Queen of Georgia († 1213)")],
            pascha+21.days:         [(.NoSign, "Holy Martyr Abraham the Bulgar, Wonderworker of Vladimir († 1229)"),
                                     (.NoSign, "Righteous Tabitha of Joppa (1st C)")],
            pascha+24.days:         [(.None,   "Mid-Pentecost"),
                                     (.None,   "Mozdok and Dubensky-Krasnohorská (17th C) Icons of the Mother of God")],
            pascha+27.days:         [(.None,   "Synaxis of New Martyrs of Butovo")],
            pascha+42.days:         [(.None,   "Chelnskoy and Pskov-Kiev Caves called “Tenderness” icons of the Mother of God")],
            pascha+48.days:         [(.None,   "Trinity Saturday; Commemoration of the Departed")],
            pentecost+1.days:       [(.None,   "Day of the Holy Spirit"),
                                     (.None,   "Icons of the Mother of God “Tupichevsk” (1847) and “Cypriot” (392)")],
            pentecost+4.days:       [(.None,   "Icon of the Mother of God “Surety of Sinners” in Korets (1622)")],
            pentecost+7.days:       [(.None,   "Feast of All Saints"),
                                     (.None,   "Icons of the Mother of God: “the Softener of evil hearts” and “the Indestructible Wall”")],
            pentecost+14.days:      [(.None,   "All Saints who have shown forth in the land of Russia")],
        ]
        
        var beforeAfterFeasts :[NSDate: [(FeastType, String)]] = [
            pascha+38.days:         [(.None,   "Apodosis of Pascha")],
            pascha+40.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+41.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+42.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+43.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+44.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+45.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+46.days:         [(.None,   "Afterfeast of the Ascension")],
            pascha+47.days:         [(.None,   "Apodosis of the Ascension")],
            pentecost+6.days:       [(.None,   "Apodosis of Pentecost")],
            
            NSDateComponents(2, 1, year).toDate(): [(.NoSign, "Forefeast of the Nativity")],
            NSDateComponents(3, 1, year).toDate(): [(.NoSign, "Forefeast of the Nativity")],
            NSDateComponents(4, 1, year).toDate(): [(.NoSign, "Forefeast of the Nativity")],
            NSDateComponents(5, 1, year).toDate(): [(.NoSign, "Forefeast of the Nativity")],
            NSDateComponents(6, 1, year).toDate(): [(.NoSign, "Forefeast of the Nativity")],
            NSDateComponents(8, 1, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of Our Lord")],
            NSDateComponents(9, 1, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of Our Lord")],
            NSDateComponents(10, 1, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of Our Lord")],
            NSDateComponents(11, 1, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of Our Lord")],
            NSDateComponents(12, 1, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of Our Lord")],
            NSDateComponents(13, 1, year).toDate(): [(.Doxology, "Apodosis of the Nativity of Christ")],
            NSDateComponents(15, 1, year).toDate(): [(.NoSign, "Forefeast of Theophany")],
            NSDateComponents(16, 1, year).toDate(): [(.NoSign, "Forefeast of Theophany")],
            NSDateComponents(17, 1, year).toDate(): [(.NoSign, "Forefeast of Theophany")],
            NSDateComponents(18, 1, year).toDate(): [(.NoSign, "Forefeast of Theophany")],
            NSDateComponents(20, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(21, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(22, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(23, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(24, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(25, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(26, 1, year).toDate(): [(.NoSign, "Afterfeast of the Theophany")],
            NSDateComponents(27, 1, year).toDate(): [(.NoSign, "Apodosis of the Theophany")],

            NSDateComponents(18, 8, year).toDate(): [(.SixVerse, "Forefeast of the Transfiguration of the Lord")],
            NSDateComponents(20, 8, year).toDate(): [(.NoSign, "Afterfeast of the Transfiguration of the Lord")],
            NSDateComponents(21, 8, year).toDate(): [(.NoSign, "Afterfeast of the Transfiguration of the Lord")],
            NSDateComponents(22, 8, year).toDate(): [(.NoSign, "Afterfeast of the Transfiguration of the Lord")],
            NSDateComponents(23, 8, year).toDate(): [(.NoSign, "Afterfeast of the Transfiguration of the Lord")],
            NSDateComponents(24, 8, year).toDate(): [(.NoSign, "Afterfeast of the Transfiguration of the Lord")],
            NSDateComponents(25, 8, year).toDate(): [(.NoSign, "Afterfeast of the Transfiguration of the Lord")],
            NSDateComponents(26, 8, year).toDate(): [(.Doxology, "Apodosis of the Transfiguration of the Lord")],
            NSDateComponents(27, 8, year).toDate(): [(.SixVerse, "Forefeast of the Dormition of the Mother of God")],
            NSDateComponents(29, 8, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(30, 8, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(31, 8, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(1, 9, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(2, 9, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(3, 9, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(4, 9, year).toDate(): [(.NoSign, "Afterfeast of the Dormition")],
            NSDateComponents(5, 9, year).toDate(): [(.Doxology, "Apodosis of the Dormition")],

            NSDateComponents(20, 9, year).toDate(): [(.NoSign, "Forefeast of the Nativity of the Theotokos")],
            NSDateComponents(22, 9, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of the Theotokos")],
            NSDateComponents(23, 9, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of the Theotokos")],
            NSDateComponents(24, 9, year).toDate(): [(.NoSign, "Afterfeast of the Nativity of the Theotokos")],
            NSDateComponents(25, 9, year).toDate(): [(.Doxology, "Apodosis of the Nativity of the Theotokos")],
            NSDateComponents(26, 9, year).toDate(): [(.NoSign, "Forefeast of the Exaltation of the Cross")],
            NSDateComponents(28, 9, year).toDate(): [(.NoSign, "Afterfeast of the Exaltation of the Cross")],
            NSDateComponents(29, 9, year).toDate(): [(.NoSign, "Afterfeast of the Exaltation of the Cross")],
            NSDateComponents(30, 9, year).toDate(): [(.NoSign, "Afterfeast of the Exaltation of the Cross")],
            NSDateComponents(1, 10, year).toDate(): [(.NoSign, "Afterfeast of the Exaltation of the Cross")],
            NSDateComponents(2, 10, year).toDate(): [(.NoSign, "Afterfeast of the Exaltation of the Cross")],
            NSDateComponents(3, 10, year).toDate(): [(.NoSign, "Afterfeast of the Exaltation of the Cross")],
            NSDateComponents(4, 10, year).toDate(): [(.Doxology, "Apodosis of the Exaltation of the Cross")],
            NSDateComponents(3, 12, year).toDate(): [(.NoSign, "Forefeast of the Entry of the Theotokos")],
            NSDateComponents(5, 12, year).toDate(): [(.NoSign, "Afterfeast of the Entry of the Theotokos")],
            NSDateComponents(6, 12, year).toDate(): [(.NoSign, "Afterfeast of the Entry of the Theotokos")],
            NSDateComponents(7, 12, year).toDate(): [(.NoSign, "Afterfeast of the Entry of the Theotokos")],
            NSDateComponents(8, 12, year).toDate(): [(.Doxology, "Apodosis of the Entry of the Theotokos")],

        ]
        
        dateFeastDescr += miscFeasts
        dateFeastDescr += beforeAfterFeasts
        
        // Sources: 
        // http://azbyka.ru/days/p-tablica-dnej-predprazdnstv-poprazdnstv-i-otdanij-dvunadesjatyh-nepodvizhnyh-i-podvizhnyh-gospodskih-prazdnikov
        
        let annunciation = NSDateComponents(7,  4, year).toDate()
        var annunciationFeasts = [NSDate: [(FeastType, String)]]()
        
        switch (annunciation) {
        case d(.StartOfYear) ..< d(.LazarusSaturday):
            annunciationFeasts = [
                annunciation-1.days: [(.SixVerse, "Forefeast of the Annunciation")],
                annunciation+1.days: [(.Doxology, "Apodosis of the Annunciation")],
            ]
        case d(.LazarusSaturday):
            annunciationFeasts = [
                annunciation-1.days: [(.SixVerse, "Forefeast of the Annunciation")],
            ]

        default:
            break
        }
        
        dateFeastDescr += annunciationFeasts

        // АРХИМАНДРИТ ИОАНН ( МАСЛОВ). КОНСПЕКТ ПО ЛИТУРГИКЕ ДЛЯ 3-го класса
        // Глава: СРЕТЕНИЕ ГОСПОДНЕ (2 февраля)

        let meetingOfLord = NSDateComponents(15, 2, year).toDate()
        var meetingOfLordFeasts = [NSDate: [(FeastType, String)]]()
        
        meetingOfLordFeasts = [
            meetingOfLord-1.days: [(.SixVerse, "Forefeast of the Meeting of the Lord")],
        ]
        
        var lastDay = meetingOfLord
        
        switch (meetingOfLord) {
        case d(.StartOfYear) ..< d(.SundayOfProdigalSon)-1.days:
            lastDay = meetingOfLord+7.days

        case d(.SundayOfProdigalSon)-1.days ... d(.SundayOfProdigalSon)+2.days:
            lastDay = d(.SundayOfProdigalSon)+5.days

        case d(.SundayOfProdigalSon)+3.days ..< d(.SundayOfDreadJudgement):
            lastDay = d(.SundayOfDreadJudgement) + 2.days
            
        case d(.SundayOfDreadJudgement) ... d(.SundayOfDreadJudgement)+1.days:
            lastDay = d(.SundayOfDreadJudgement) + 4.days

        case d(.SundayOfDreadJudgement)+2.days ... d(.SundayOfDreadJudgement)+3.days:
            lastDay = d(.SundayOfDreadJudgement) + 6.days

        case d(.SundayOfDreadJudgement)+4.days ... d(.SundayOfDreadJudgement)+6.days:
            lastDay = d(.CheesefareSunday)

        default:
            break
        }

        if (lastDay != meetingOfLord) {
            for afterfeastDay in DateRange(meetingOfLord+1.days, lastDay-1.days) {
                meetingOfLordFeasts += [
                    afterfeastDay: [(.NoSign, "Afterfeast of the Meeting of the Lord")],
                ]
            }
            meetingOfLordFeasts += [
                lastDay: [(.Doxology, "Apodosis of the Meeting of the Lord")]
            ]
        }

        dateFeastDescr += meetingOfLordFeasts

    }
    
    
    static func generateFeastDates(year: Int) {
        let pascha = paschaDay(year)
        let greatLentStart = pascha-48.days

        let movingFeasts : [NSDate: [NameOfDay]] = [
            greatLentStart-22.days:                   [.SundayOfPublicianAndPharisee],
            greatLentStart-15.days:                   [.SundayOfProdigalSon],
            greatLentStart-8.days:                    [.SundayOfDreadJudgement],
            greatLentStart-1.days:                    [.CheesefareSunday],
            greatLentStart:                           [.BeginningOfGreatLent],
            pascha-8.days:                            [.LazarusSaturday],
            pascha-7.days:                            [.PalmSunday],
            pascha:                                   [.Pascha],
            pascha+7.days:                            [.Sunday2AfterPascha],
            pascha+14.days:                           [.Sunday3AfterPascha],
            pascha+21.days:                           [.Sunday4AfterPascha],
            pascha+28.days:                           [.Sunday5AfterPascha],
            pascha+35.days:                           [.Sunday6AfterPascha],
            pascha+42.days:                           [.Sunday7AfterPascha],

            pascha+39.days:                           [.Ascension],
            pascha+49.days:                           [.Pentecost],
            pascha+57.days:                           [.BeginningOfApostolesFast],
        ]
        
        let fixedFeasts : [NSDate: [NameOfDay]] = [
            NSDateComponents(1,  1, year).toDate():   [.StartOfYear],
            NSDateComponents(6,  1, year).toDate():   [.EveOfNativityOfGod],
            NSDateComponents(7,  1, year).toDate():   [.NativityOfGod],
            NSDateComponents(14, 1, year).toDate():   [.Circumcision],
            NSDateComponents(18, 1, year).toDate():   [.EveOfTheophany],
            NSDateComponents(19, 1, year).toDate():   [.Theophany],
            NSDateComponents(15, 2, year).toDate():   [.MeetingOfLord],
            NSDateComponents(7,  4, year).toDate():   [.Annunciation],
            NSDateComponents(7,  7, year).toDate():   [.NativityOfJohn],
            NSDateComponents(12, 7, year).toDate():   [.PeterAndPaul],
            NSDateComponents(14, 8, year).toDate():   [.BeginningOfDormitionFast],
            NSDateComponents(19, 8, year).toDate():   [.Transfiguration],
            NSDateComponents(28, 8, year).toDate():   [.Dormition],
            NSDateComponents(11, 9, year).toDate():   [.BeheadingOfJohn],
            NSDateComponents(21, 9, year).toDate():   [.NativityOfTheotokos],
            NSDateComponents(27, 9, year).toDate():   [.ExaltationOfCross],
            NSDateComponents(14, 10, year).toDate():  [.VeilOfTheotokos],
            NSDateComponents(28, 11, year).toDate():  [.BeginningOfNativityFast],
            NSDateComponents(4,  12, year).toDate():  [.EntryIntoTemple],
            NSDateComponents(19, 12, year).toDate():  [.StNicholas],
            NSDateComponents(31, 12, year).toDate():  [.EndOfYear],
        ];

        feastDates += movingFeasts
        feastDates += fixedFeasts
        
        let exaltation = NSDateComponents(27, 9, year).toDate()
        let exaltationWeekday = NSDateComponents(date: exaltation).weekday
        feastDates += [exaltation + (8-exaltationWeekday).days: [.SundayAfterExaltation]]

        var exaltationSatOffset = (exaltationWeekday == 7) ? 7 : 7-exaltationWeekday
        feastDates += [exaltation + exaltationSatOffset.days: [.SaturdayAfterExaltation]]
        
        var exaltationSunOffset = (exaltationWeekday == 1) ? 7 : exaltationWeekday-1
        feastDates += [exaltation - exaltationSunOffset.days: [.SundayBeforeExaltation]]

        feastDates += [exaltation - exaltationWeekday.days: [.SaturdayBeforeExaltation]]

        let nativity = NSDateComponents(7, 1, year).toDate()
        let nativityWeekday = NSDateComponents(date:nativity).weekday
        let nativitySunOffset = (nativityWeekday == 1) ? 7 : (nativityWeekday-1)
        if nativitySunOffset != 7 {
            feastDates += [nativity - nativitySunOffset.days: [.SundayBeforeNativity]]
        }

        if nativityWeekday != 7 {
            feastDates += [nativity - nativityWeekday.days: [.SaturdayBeforeNativity]]
        }

        feastDates += [nativity + (8-nativityWeekday).days: [.SundayAfterNativity]]
        
        var nativitySatOffset = (nativityWeekday == 7) ? 7 : 7-nativityWeekday
        feastDates += [nativity + nativitySatOffset.days: [.SaturdayAfterNativity]]
        
        let nativityNextYear = NSDateComponents(7, 1, year+1).toDate()
        let nativityNextYearWeekday = NSDateComponents(date:nativityNextYear).weekday
        var nativityNextYearSunOffset = (nativityNextYearWeekday == 1) ? 7 : (nativityNextYearWeekday-1)

        if nativityNextYearSunOffset == 7 {
            feastDates += [NSDateComponents(31, 12, year).toDate(): [.SundayBeforeNativity]]
        }
        
        if nativityNextYearWeekday == 7 {
            feastDates += [NSDateComponents(31, 12, year).toDate(): [.SaturdayBeforeNativity]]
        }
        
        nativityNextYearSunOffset += 7
        feastDates += [nativityNextYear - nativityNextYearSunOffset.days: [.SundayOfForefathers]]
        
        let theophany = NSDateComponents(19, 1, year).toDate()
        let theophanyWeekday = NSDateComponents(date:theophany).weekday

        var theophanySunOffset = (theophanyWeekday == 1) ?  7 : (theophanyWeekday-1)
        var theophanySatOffset = (theophanyWeekday == 7) ? 7 : 7-theophanyWeekday

        feastDates += [theophany - theophanySunOffset.days: [.SundayBeforeTheophany]]
        feastDates += [theophany - theophanyWeekday.days: [.SaturdayBeforeTheophany]]
        feastDates += [theophany + (8-theophanyWeekday).days: [.SundayAfterTheophany]]
        feastDates += [theophany + theophanySatOffset.days: [.SaturdayAfterTheophany]]
        
        let newMartyrs = NSDateComponents(7, 2, year).toDate()
        let newMartyrsWeekday = NSDateComponents(date:newMartyrs).weekday
        let newMartyrsSunOffset = (newMartyrsWeekday == 1) ? 0 : 8-newMartyrsWeekday
        feastDates += [newMartyrs + newMartyrsSunOffset.days: [.NewMartyrsConfessorsOfRussia]]

        let start: Int = NameOfDay.StartOfYear.rawValue
        let end: Int = NameOfDay.EndOfYear.rawValue
        
        for index in start...end {
            let code = NameOfDay(rawValue: index)
            saveFeastDate(code!, year)
        }

    }

    static func isGreatFeast(date: NSDate) -> Bool {
        if let feastCodes = feastDates[date] {
            for code in feastCodes {
                if contains(greatFeastCodes, code) {
                    return true
                }
            }
        }
        return false
    }
    
    static func getDayDescription(date: NSDate) -> [(FeastType, String)] {
        var result = [(FeastType, String)]()
        
        setDate(date)

        if let codes = feastDates[date] {
            for code in codes {
                if let feasts = codeFeastDescr[code] {
                    for feast in feasts {
                        result.append((feast.0, Translate.s(feast.1)))
                    }
                }
            }
        }

        result.sort { $0.0.rawValue < $1.0.rawValue }

        if let feasts = dateFeastDescr[date] {
            for feast in feasts {
                result.append((feast.0, Translate.s(feast.1)))
            }
        }
        
        return result
    }
    
    static func getWeekDescription(date: NSDate) -> String? {
        
        let sundays : [NameOfDay:String] = [
            .SundayOfPublicianAndPharisee: "Sunday of the Publican and the Pharisee",
            .SundayOfProdigalSon: "Sunday of the Prodigal Son",
            .SundayOfDreadJudgement: "Sunday of the Dread Judgement",
            .CheesefareSunday: "Cheesefare Sunday (Forgiveness Sunday): Commemoration of the Expulsion of Adam from Paradise",
            .Sunday2AfterPascha: "Second Sunday after Pascha. Thomas Sunday, or Antipascha",
            .Sunday3AfterPascha: "Third Sunday after Pascha. Sunday of the Myrrhbearing Women",
            .Sunday4AfterPascha: "Fourth Sunday after Pascha. Sunday of the Paralytic",
            .Sunday5AfterPascha: "Fifth Sunday after Pascha. Sunday of the Samaritan Woman",
            .Sunday6AfterPascha: "Sixth Sunday after Pascha. Sunday of the Blind Man",
            .Sunday7AfterPascha: "Seventh Sunday after Pascha. Commemoration of the 318 Holy Fathers of the First Ecumenical Council (325)",
            .LazarusSaturday: "Saturday of Palms (Lazarus Saturday)",
        ];
        
        setDate(date)

        if let codes = feastDates[date] {
            for code in codes {
                if let descr = sundays[code] {
                    return Translate.s(descr)
                }
            }
        }
        
        let dayOfWeek = (currentWeekday == .Sunday) ? "Sunday" : "Week"
        
        switch (date) {
        case d(.StartOfYear) ..< d(.SundayOfPublicianAndPharisee):
            return  String(format: Translate.s("\(dayOfWeek) %@ after Pentecost"), Translate.stringFromNumber(((paschaDay(currentYear-1)+50.days) >> date)/7+1))
            
        case d(.SundayOfPublicianAndPharisee)+1.days ..< d(.SundayOfProdigalSon):
            return Translate.s("Week of the Publican and the Pharisee")

        case d(.SundayOfProdigalSon)+1.days ..< d(.SundayOfDreadJudgement):
            return Translate.s("Week of the Prodigal Son")

        case d(.SundayOfDreadJudgement)+1.days ..< d(.BeginningOfGreatLent)-1.days:
            return Translate.s("Week of the Dread Judgement")

        case d(.BeginningOfGreatLent) ..< d(.PalmSunday):
            return  String(format: Translate.s("\(dayOfWeek) %@ of Great Lent"), Translate.stringFromNumber((d(.BeginningOfGreatLent) >> date)/7+1))
        
        case d(.PalmSunday)+1.days:
            return Translate.s("Great Monday")
            
        case d(.PalmSunday)+2.days:
            return Translate.s("Great Tuesday")

        case d(.PalmSunday)+3.days:
            return Translate.s("Great Wednesday")

        case d(.PalmSunday)+4.days:
            return Translate.s("Great Thursday")
            
        case d(.PalmSunday)+5.days:
            return Translate.s("Great Friday")

        case d(.PalmSunday)+6.days:
            return Translate.s("Great Saturday")
            
        case d(.Pascha)+1.days ..< d(.Pascha)+7.days:
            return Translate.s("Bright Week")
            
        case d(.Pascha)+8.days ..< d(.Pentecost):
            let weekNum = (d(.Pascha) >> date)/7+1
            return (currentWeekday == .Sunday) ? nil : String(format: Translate.s("Week %@ after Pascha"), Translate.stringFromNumber(weekNum))
            
        case d(.Pentecost)+1.days ... d(.EndOfYear):
            return  String(format: Translate.s("\(dayOfWeek) %@ after Pentecost"), Translate.stringFromNumber(((d(.Pentecost)+1.days) >> date)/7+1))
            
        default: return nil
        }
        
    }
    
    static func getToneDescription(date: NSDate) -> String? {
        func tone(#dayNum: Int) -> Int {
            let reminder = (dayNum/7) % 8
            return (reminder == 0) ? 8 : reminder
        }

        setDate(date)

        switch (date) {
        case d(.StartOfYear) ..< d(.PalmSunday):
            return String(format: Translate.s("Tone %@"), Translate.stringFromNumber(tone(dayNum: paschaDay(currentYear-1) >> date)))

        case d(.Pascha)+7.days ... d(.EndOfYear):
            return String(format: Translate.s("Tone %@"), Translate.stringFromNumber(tone(dayNum: d(.Pascha) >> date)))

        default: return nil
        }
    }

    static func getFastingDescription(date: NSDate) -> (FastingType, String) {

        setDate(date)
        
        switch date {
        case d(.MeetingOfLord):
            if date == d(.BeginningOfGreatLent) {
                return (.Vegetarian, Translate.s("Great Lent"))
            } else {
                return (.NoFast, Translate.s("No fast"))
            }

        case d(.Theophany):
            return (.NoFast, Translate.s("No fast"))
            
        case d(.NativityOfTheotokos),
        d(.PeterAndPaul),
        d(.Dormition),
        d(.VeilOfTheotokos):
            return (currentWeekday == .Wednesday ||
                    currentWeekday == .Friday) ? (.FishAllowed, Translate.s("Fish allowed")) : (.NoFast, Translate.s("No fast"))
            
        case d(.NativityOfJohn),
        d(.Transfiguration),
        d(.EntryIntoTemple),
        d(.StNicholas),
        d(.PalmSunday):
            return (.FishAllowed, Translate.s("Fish allowed"))
            
        case d(.EveOfTheophany),
        d(.BeheadingOfJohn),
        d(.ExaltationOfCross):
            return (.Vegetarian, Translate.s("Fast day"))
            
        case d(.StartOfYear):
            return (currentWeekday == .Saturday ||
                    currentWeekday == .Sunday) ? (.FishAllowed, Translate.s("Nativity Fast")) : (.Vegetarian, Translate.s("Nativity Fast"))
            
        case d(.StartOfYear)+1.days ..< d(.NativityOfGod):
            return (.Vegetarian, Translate.s("Nativity Fast"))
            
        case d(.NativityOfGod) ..< d(.EveOfTheophany):
            return (.FastFree, Translate.s("Svyatki"))
            
        case d(.SundayOfPublicianAndPharisee)+1.days ... d(.SundayOfProdigalSon):
            return (.FastFree, Translate.s("Fast-free week"))
            
        case d(.SundayOfDreadJudgement)+1.days ..< d(.BeginningOfGreatLent):
            return (.Cheesefare, Translate.s("Maslenitsa"))
            
        case d(.BeginningOfGreatLent) ..< d(.PalmSunday):
            return (date == d(.Annunciation)) ? (.FishAllowed, Translate.s("Fish allowed")) : (.Vegetarian, Translate.s("Great Lent"))
            
        case d(.PalmSunday)+1.days ..< d(.Pascha):
            return (.Vegetarian, Translate.s("Vegetarian"))
            
        case d(.Pascha)+1.days ... d(.Pascha)+7.days:
            return (.FastFree, Translate.s("Fast-free week"))
            
        case d(.Pentecost)+1.days ... d(.Pentecost)+7.days:
            return (.FastFree, Translate.s("Fast-free week"))
            
        case d(.BeginningOfApostolesFast) ... d(.PeterAndPaul)-1.days:
            return (currentWeekday == .Monday ||
                    currentWeekday == .Wednesday ||
                    currentWeekday == .Friday) ? (.Vegetarian, Translate.s("Apostoles' Fast")) : (.FishAllowed, Translate.s("Apostoles' Fast"))
            
        case d(.BeginningOfDormitionFast) ... d(.Dormition)-1.days:
            return (.Vegetarian, Translate.s("Dormition Fast"))
            
        case d(.BeginningOfNativityFast) ..< d(.StNicholas):
            return (currentWeekday == .Monday ||
                    currentWeekday == .Wednesday ||
                    currentWeekday == .Friday) ? (.Vegetarian, Translate.s("Nativity Fast")) : (.FishAllowed, Translate.s("Nativity Fast"))
            
        case d(.StNicholas) ... d(.EndOfYear):
            return (currentWeekday == .Saturday ||
                    currentWeekday == .Sunday) ? (.FishAllowed, Translate.s("Nativity Fast")) : (.Vegetarian, Translate.s("Nativity Fast"))
            
        case d(.NativityOfGod) ..< d(.Pentecost)+8.days:
            return (currentWeekday == .Wednesday ||
                    currentWeekday == .Friday) ? (.FishAllowed, Translate.s("Fish allowed")) : (.NoFast, Translate.s("No fast"))
            
        default:
            return (currentWeekday == .Wednesday ||
                    currentWeekday == .Friday) ? (.Vegetarian, Translate.s("Vegetarian")) : (.NoFast, Translate.s("No fast"))
        }
    }
}

typealias Cal = ChurchCalendar

