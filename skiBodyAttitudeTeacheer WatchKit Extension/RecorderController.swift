//
//  RecorderController.swift
//  skiBodyAttitudeTeacheer WatchKit Extension
//
//  Created by koyanagi on 2021/10/29.
//

import WatchKit
import Foundation
import CoreMotion

class RecordController:NSObject, WKExtendedRuntimeSessionDelegate{
    let motionManager = CMMotionManager()
//    var connector = PhoneConnector()
    
    var session: WKExtendedRuntimeSession!
    func startSession() {
        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
    }
    
    func stopSession(){
        session.invalidate()
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            if let motion = motion {
                connector.send(motion: motion,timeStamp: Date(timeInterval: motion.timestamp, since: Date.now.addingTimeInterval( ProcessInfo.processInfo.systemUptime * -1)).timeIntervalSince1970)
            }
        }
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        motionManager.stopDeviceMotionUpdates()
    }

    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
    }
}

