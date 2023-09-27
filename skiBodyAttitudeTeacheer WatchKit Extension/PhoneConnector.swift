//
//  PhoneConnector.swift
//  skiBodyAttitudeTeacheer WatchKit Extension
//
//  Created by koyanagi on 2021/10/26.
//

import Foundation
import UIKit
import WatchConnectivity
import CoreMotion
import WatchKit

class PhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    
    @Published var receivedMessage = "PHONE : 未受信"
    
    @Published var count = 0
    
    @Published var motion :[CMDeviceMotion] = []
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            print("didReceiveMessage: \(message)")
            
            DispatchQueue.main.async {
                self.receivedMessage = "PHONE : \(message["PHONE_COUNT"] as! Int)"
            }
        }
    
    func send(motion: CMDeviceMotion, timeStamp: Double) {
            if WCSession.default.isReachable {
                count += 1
                print(timeStamp)
                WCSession
                WCSession.default.sendMessage(
                    ["WATCH_COUNT" : count,
                     "motion.userAcceleration.x":motion.userAcceleration.x,
                     "motion.userAcceleration.y":motion.userAcceleration.y,
                     "motion.userAcceleration.z":motion.userAcceleration.z,
                   "motion.rotationRate.x":motion.rotationRate.x,
                   "motion.rotationRate.y":motion.rotationRate.y,
                   "motion.rotationRate.z":motion.rotationRate.z,
                   "motion.attitude.pitch":motion.attitude.pitch,
                   "motion.attitude.roll":motion.attitude.roll,
                   "motion.attitude.yaw":motion.attitude.yaw,
                   "motion.timestamp": timeStamp
                  ]
                                               , replyHandler: nil) { error in
                    print(error)
                }
            }
        }
    
}
struct ConnetedMessage{
    let watchCount : Int
    let motion: CMDeviceMotion
}
