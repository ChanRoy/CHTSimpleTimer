//
//  ViewController.swift
//  SimpleTimer
//
//  Created by 王 巍 on 14-8-1.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

import UIKit
import CHTSimpleTimerKit

let defaultTimeInterval: TimeInterval = 15

class ViewController: UIViewController {
                            
    @IBOutlet weak var lblTimer: UILabel!
    
    var timer: CHTTimer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /************************add by cht --> begin***************************/
        
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: .UIApplicationWillResignActive, object: nil)
        
        if isTimerFinish {
            
            lblTimer.text = "00:00"
            showFinishAlert(finished: true)
        }
        
        
    }
    func appResignActive(){
        
        if timer == nil{
            
            clearUserDefaults()
        }else{
            
            if timer.running {
                
                saveUserDefaults()
            }else{
                
                clearUserDefaults()
            }
        }
    }
    
    private func saveUserDefaults(){
        
        let userDefault = UserDefaults.init(suiteName: "group.CHTSimpleTimerGroup")
        userDefault?.set(Int(timer.leftTime), forKey: "com.roy.CHTSimpleTimer.leftTime")
        userDefault?.set(Int(NSDate().timeIntervalSince1970), forKey: "com.roy.CHTSimpleTimer.quitDate")
        
        userDefault?.synchronize()
    }
    
    
    private func clearUserDefaults(){
        
        let userDefault = UserDefaults.init(suiteName: "group.CHTSimpleTimerGroup")
        userDefault?.removeObject(forKey: "com.roy.CHTSimpleTimer.leftTime")
        userDefault?.removeObject(forKey: "com.roy.CHTSimpleTimer.quitDate")
        
        userDefault?.synchronize()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func updateLabel() {
        lblTimer.text = timer.leftTimeString
    }
    
    fileprivate func showFinishAlert(finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak ac] action in ac!.dismiss(animated: true, completion: nil)}))
            
        present(ac, animated: true, completion: nil)
    }

    @IBAction func btnStartPressed(_ sender: AnyObject) {
        if timer == nil {
            timer = CHTTimer(timeInteral: defaultTimeInterval)
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
                print("error: \(realError.code)")
            }
        }
    }
    
    @IBAction func btnStopPressed(_ sender: AnyObject) {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop()
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }

}

