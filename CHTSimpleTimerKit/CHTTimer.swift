//
//  CHTTimer.swift
//  SimpleTimer
//
//  Created by cht on 16/11/22.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

import UIKit

let timerErrorDomain = "SimpleTimerError"

public enum SimperTimerError: Int {
    case alreadyRunning = 1001
    case negativeLeftTime = 1002
    case notRunning = 1003
}

extension TimeInterval {
    func toString() -> String {
        let totalSecond = Int(self)
        let minute = totalSecond / 60
        let second = totalSecond % 60
        
        switch (minute, second) {
        case (0...9, 0...9):
            return "0\(minute):0\(second)"
        case (0...9, _):
            return "0\(minute):\(second)"
        case (_, 0...9):
            return "\(minute):0\(second)"
        default:
            return "\(minute):\(second)"
        }
    }
}


public class CHTTimer: NSObject {

    public var running: Bool = false
    
    public var leftTime: TimeInterval {
        didSet {
            if leftTime < 0 {
                leftTime = 0
            }
        }
    }
    
    public var leftTimeString: String {
        get {
            return leftTime.toString()
        }
    }
    
    fileprivate var timerTickHandler: ((TimeInterval) -> ())? = nil
    fileprivate var timerStopHandler: ((Bool) ->())? = nil
    fileprivate var timer: Foundation.Timer!
    
    public init(timeInteral: TimeInterval) {
        leftTime = timeInteral
    }
    
    public func start(updateTick: ((TimeInterval) -> Void)?, stopHandler: ((Bool) -> Void)?) -> (start: Bool, error: NSError?) {
        if running {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.alreadyRunning.rawValue, userInfo:nil))
        }
        
        
        
        if leftTime < 0 {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.negativeLeftTime.rawValue, userInfo:nil))
        }
        
        timerTickHandler = updateTick
        timerStopHandler = stopHandler
        
        running = true
        
        timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(CHTTimer.countTick), userInfo: nil, repeats: true)
        
        return (true, nil)
    }
    
    public func stop() -> (stopped: Bool, error: NSError?) {
        if !running {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.notRunning.rawValue, userInfo:nil))
        }
        
        running = false
        timer.invalidate()
        timer = nil
        
        if let stopHandler = timerStopHandler {
            stopHandler(leftTime <= 0)
        }
        
        timerStopHandler = nil
        timerTickHandler = nil
        
        return (true, nil)
    }
    
    @objc fileprivate func countTick() {
        leftTime = leftTime - 1
        if let tickHandler = timerTickHandler {
            tickHandler(leftTime)
        }
        if leftTime <= 0 {
            stop()
        }
        
    }
    
}
