//
//  TodayViewController.swift
//  Timer
//
//  Created by Wilson-Yuan on 15/9/3.
//  Copyright (c) 2015年 OneV's Den. All rights reserved.
//

import UIKit
import NotificationCenter
import SimpleTimerKit

let groupSuiteName = "group.userDefault"
let groupLeftTime = "com.group.userDefault.leftTimer"
let groupQuitdate = "com.grroup.userDefault.quitdate"

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: Timer!
    
    @IBOutlet weak var finishedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let userDefault = NSUserDefaults(suiteName: groupSuiteName)
        let leftTimeWhenQuit = userDefault?.integerForKey(groupLeftTime)
        let quiteDate = userDefault?.integerForKey(groupQuitdate)
        
        //计算剩余时间
        let passedTimFromQuit = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: NSTimeInterval(quiteDate!)))
        let leftTime = leftTimeWhenQuit! - Int(passedTimFromQuit)
        
        if leftTime > 0 {
            timer = Timer(timeInteral: NSTimeInterval(leftTime))
            
            timer.start(updateTick: {
                [weak self] leftTick in self!.updateLabel()
                }, stopHandler: {
                    [weak self] finished in
                    self!.finishedBtn.hidden = false
            })
       
        } else {
            self.finishedBtn.hidden = false
        }

//        NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: "http://")!), completionHandler: { (data, _, error) -> Void in
//            
//            var string  = NSString(data: data, encoding: NSUTF8StringEncoding)
//          
//            println("RequestString: \(string)")
//            
//        }).resume()
    }
    
    private func updateLabel() {
        timeLabel.text = timer.leftTimeString
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func finishedBtnAction(sender: AnyObject) {
        extensionContext?.openURL(NSURL(string: "simpleTimer://finished")!, completionHandler: nil);
        
    }
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
