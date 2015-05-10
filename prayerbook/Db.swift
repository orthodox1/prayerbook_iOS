//
//  Db.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 01.12.14.
//  Copyright (c) 2014 Alexey Smirnov. All rights reserved.
//

import Foundation
import UIKit
import Squeal

let NewTestament: [(String, String)] = [
    ("Gospel of St Matthew", "matthew"),
    ("Gospel of St Mark", "mark"),
    ("Gospel of St Luke", "luke"),
    ("Gospel of St John", "john"),
    ("Acts of the Apostles", "acts"),
    ("Epistle of St Paul to Romans", "rom"),
    ("1st Epistle of St Paul to Corinthians", "1cor"),
    ("2nd Epistle of St Paul to Corinthians", "2cor"),
    ("Epistle of St Paul to Galatians", "gal"),
    ("Epistle of St Paul to Ephesians", "ephes"),
    ("Epistle of St Paul to Philippians", "phil"),
    ("Epistle of St Paul to Colossians", "col"),
    ("1st Epistle of St Paul Thessalonians", "1thess"),
    ("2nd Epistle of St Paul Thessalonians", "2thess"),
    ("1st Epistle of St Paul to Timothy", "1tim"),
    ("2nd Epistle of St Paul to Timothy", "2tim"),
    ("Epistle of St Paul to Titus", "tit"),
    ("Epistle of St Paul to Philemon", "philem"),
    ("Epistle of St Paul to Hebrews", "heb"),
    ("General Epistle of James", "james"),
    ("1st Epistle General of Peter", "1pet"),
    ("2nd General Epistle of Peter", "2pet"),
    ("1st Epistle General of John", "1john"),
    ("2nd Epistle General of John", "2john"),
    ("3rd Epistle General of John", "3john"),
    ("General Epistle of Jude", "jude"),
    ("Revelation of St John the Devine", "rev"),
    
    ("Genesis", "gen"),
    ("The Proverbs", "prov"),
    ("The Book of Prophet Isaiah", "isa")
    
]

let OldTestament: [(String, String)] = [
]


struct Db {

    static func book(name: String, whereExpr: String = "") -> StepSequence {
        var error: NSError?
        let path = NSBundle.mainBundle().pathForResource(name.lowercaseString, ofType: "sqlite")!
        let db = Database(path:path, error:&error)
        return db!.selectFrom("scripture", whereExpr:whereExpr, error:&error)
    }
    
    static func numberOfChapters(name: String) -> Int {
        var error: NSError?
        let path = NSBundle.mainBundle().pathForResource(name.lowercaseString, ofType: "sqlite")!
        let db = Database(path:path, error:&error)
        
        for row in db!.query("SELECT COUNT(DISTINCT chapter) FROM scripture", error:&error) {
            let num = row![0] as! Int64
            return Int(num)
        }
        
        return 0
    }
    
}

