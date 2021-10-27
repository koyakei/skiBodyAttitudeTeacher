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
    
    func session(_ session: WCSession, didReceiveMessage message: [String: ConnetedMessage]) {
        print("didReceiveMessage: \(message["motion"])")
        
        DispatchQueue.main.async {
            self.receivedMessage = "PHONE : \(message["motion"]!.watchCount)"
        }
    }
    
    func send(motion: CMDeviceMotion) {
        if WCSession.default.isReachable {
            count += 1
            WCSession.default.sendMessage(["motion": ConnetedMessage.init(watchCount: count, motion: motion)]
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
