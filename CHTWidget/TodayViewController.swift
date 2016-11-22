//
//  TodayViewController.swift
//  CHTWidget
//
//  Created by cht on 16/11/22.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

import UIKit
import NotificationCenter
import CHTSimpleTimerKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var timer: CHTTimer?
    
    var leftTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        preferredContentSize = CGSize.init(width: 0, height: 100)
        
        let userDefault = UserDefaults.init(suiteName: "group.CHTSimpleTimerGroup")
        let leftTimeWhenQuit = userDefault?.integer(forKey: "com.roy.CHTSimpleTimer.leftTime")
//        let quitTime = userDefault?.integer(forKey: "com.roy.CHTSimpleTimer.quitTime")
        
//        let passTimeFromQuit = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(quitTime!)))
//        let currentTime = Date().timeIntervalSince1970;
//
//        let leftTime = leftTimeWhenQuit! - Int(currentTime - passTimeFromQuit)

        leftTime = Int(leftTimeWhenQuit!)
        
        
        if leftTime! >= 0 {
            
            
            timer = CHTTimer(timeInteral: TimeInterval(leftTime!))
            
            let (started, error) = (timer?.start(updateTick: {
                [weak self] leftTick in self!.updateLabel()
                }, stopHandler: nil))!
            
            if started {
                updateLabel()
            } else {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }
    
    private func updateLabel(){
        
        if Int((timer?.leftTime)!) > 0 {
            textLabel.text = timer?.leftTimeString
        }else{
            
            showOpenAppButton()
        }
        
    }
    
    private func showOpenAppButton(){
        
        textLabel.text = "Finished"
        
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 63))
//        button.backgroundColor = UIColor.yellow
        button.setTitle("Open", for: .normal)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func btnClick(){
        
        extensionContext?.open(URL.init(string: "CHTSimpleTimer://Finished")!, completionHandler: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
