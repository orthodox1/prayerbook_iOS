//
//  Prayer.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 10/5/14.
//  Copyright (c) 2014 Alexey Smirnov. All rights reserved.
//

import UIKit

class Prayer: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    let prefs = UserDefaults(suiteName: groupId)!
    var fontSize: Int = 0
    var index:Int!
    var code:String!
    var name:String!
    
    func reload() {
        let filename = String(format: "prayer_%@_%d_%@.html", code, index, Translate.language)
        let bundleName = Bundle.main.path(forResource: filename, ofType: nil)
        var txt:String! = try? String(contentsOfFile: bundleName!, encoding: String.Encoding.utf8)
        
        fontSize = prefs.integer(forKey: "fontSize")
        txt = txt.replacingOccurrences(of: "FONTSIZE", with: "\(fontSize)px")
        
        if (code == "typica") {
            let tone = Cal.getTone(Cal.currentDate)
            txt = txt.replacingOccurrences(of: "GLAS", with: Translate.stringFromNumber(tone!))
            
            let bundleTypica = Bundle.main.path(forResource: String(format: "typica_%d", tone!), ofType: "plist")
            let fragments = NSArray(contentsOfFile: bundleTypica!) as! [[String:String]]

            for (i, fragment) in fragments.enumerated() {
                txt = txt.replacingOccurrences(
                    of: String(format:"FRAGMENT%d!", i),
                    with: fragment[Translate.language]!)
                
            }
            
            let readingStr = DailyReading.getDailyReading(Cal.currentDate)[0].components(separatedBy: "#")
            let readings = Scripture.getPericope(readingStr[0], decorated: false)
            
            for (i, (title, content)) in readings.enumerated() {
                txt = txt.replacingOccurrences(
                    of: String(format:"TITLE%d", (i+1)),
                    with: title.string)

                txt = txt.replacingOccurrences(
                    of: String(format:"READING%d", (i+1)),
                    with: content.string)

            }
            
        }
        
        let button_zoom_in = UIBarButtonItem(image: UIImage(named: "zoom_in"), style: .plain, target: self, action: #selector(Prayer.zoom_in))
        let button_zoom_out = UIBarButtonItem(image: UIImage(named: "zoom_out"), style: .plain, target: self, action: #selector(Prayer.zoom_out))
        
        button_zoom_in.imageInsets = UIEdgeInsetsMake(0,0,0,-20)
        navigationItem.rightBarButtonItems = [button_zoom_out, button_zoom_in]
        
        webView.paginationBreakingMode = UIWebPaginationBreakingMode.page
        webView.paginationMode = UIWebPaginationMode.leftToRight
        webView.scrollView.isPagingEnabled = true
        webView.scrollView.bounces = false
        
        webView.loadHTMLString(txt, baseURL: nil)
        title = Translate.s(name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(Prayer.reload), name: NSNotification.Name(rawValue: optionsSavedNotification), object: nil)
        reload()
    }
    
    func zoom_in() {
        fontSize += 2
        prefs.set(fontSize, forKey: "fontSize")
        prefs.synchronize()
        
        reload()
    }
    
    func zoom_out() {
        fontSize -= 2
        prefs.set(fontSize, forKey: "fontSize")
        prefs.synchronize()
        reload()
    }

}
