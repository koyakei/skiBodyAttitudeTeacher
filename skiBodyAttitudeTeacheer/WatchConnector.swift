//
//  WatchConnector.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/26.
//

import Foundation
import UIKit
import WatchConnectivity
import CoreMotion
class WatchConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var receivedMessage = "WATCH : 未受信"
    
    @Published var count = 0
    
    @Published var motion:[CMDeviceMotion] = []
    
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
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: ConnetedMessage]) {
        print("didReceiveMessage: \(message)")
        
        DispatchQueue.main.async {
            self.receivedMessage = "WATCH : \(message["motion"]!.watchCount)"
            self.motion.append( contentsOf: [message["motion"]!.motion])
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
