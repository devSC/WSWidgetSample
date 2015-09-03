//
//  ViewController.swift
//  SimpleTimer
//
//  Created by 王 巍 on 14-8-1.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

import UIKit
import SimpleTimerKit


let defaultTimeInterval: NSTimeInterval = 10

let groupSuiteName = "group.userDefault"
let groupLeftTime = "com.group.userDefault.leftTimer"
let groupQuitdate = "com.grroup.userDefault.quitdate"


class ViewController: UIViewController {
                            
    @IBOutlet weak var lblTimer: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskfinishedInWidget", name: "taskDidFinishedInWidgetNotification", object: nil)
        
    }
    
    func applicationWillResignActive() {
        if timer == nil {
//            clearDefault()
            return;
        } else {
            if timer.running {
                saveDefault()
            } else {
                clearDefault()
            }
        }
    }
 
    private func saveDefault() {
        let userDefault = NSUserDefaults(suiteName: groupSuiteName)
        userDefault?.setInteger(Int(timer.leftTime), forKey: groupLeftTime);
        userDefault?.setInteger(Int(NSDate().timeIntervalSince1970), forKey: groupQuitdate);
        userDefault?.synchronize()
    }
    private func clearDefault() {
        let userDefault = NSUserDefaults(suiteName: groupSuiteName);
        userDefault?.setInteger(Int(timer.leftTime), forKey: groupLeftTime)
        
        userDefault?.setInteger(Int(NSDate().timeIntervalSince1970), forKey: groupQuitdate);
        
        userDefault?.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateLabel() {
        lblTimer.text = timer.leftTimeString
    }
    
    private func showFinishAlert(# finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[weak ac] action in ac!.dismissViewControllerAnimated(true, completion: nil)}))
            
        presentViewController(ac, animated: true, completion: nil)
    }

    @IBAction func btnStartPressed(sender: AnyObject) {
        if timer == nil {
            timer = Timer(timeInteral: defaultTimeInterval)
        }
        
        let (started, error) = timer.start(updateTick: {
                [weak self] leftTick in self!.updateLabel()
            }, stopHandler: {
                [weak self] finished in
                self!.showFinishAlert(finished: finished)
                self!.timer = nil
            })
        
        if started {
            updateLabel()
        } else {
            if let realError = error {
                println("error: \(realError.code)")
            }
        }
    }
    
    func taskfinishedInWidget() {
        finishedAlertView(finished: true)
    }
    
    func finishedAlertView(# finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[weak ac] action in ac!.dismissViewControllerAnimated(true, completion: nil)}))
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func btnStopPressed(sender: AnyObject) {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop()
            if !stopped {
                if let realError = error {
                    println("error: \(realError.code)")
                }
            }
        }
    }

}

