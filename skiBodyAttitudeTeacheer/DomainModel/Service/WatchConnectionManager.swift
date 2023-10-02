//
//  WatchConnectionSender.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/23.
//

import Foundation
import WatchConnectivity

class WatchConnectionManager: NSObject, ObservableObject {
    
    var isConnected: Bool = false
    override init() {
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    
    private func sendDiscoveryToken(riderDataForWatch :UMBMeasuredData ) {
        do {
            try WCSession.default.updateApplicationContext([Helper.ridersDataTokenKey: riderDataForWatch])
        } catch let error {
            print("failed to send NIDiscoveryToken: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectionManager :WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard error == nil else {
            print("WCSession failed to activate: \(error!.localizedDescription)")
            return
        }
        
        switch activationState {
        case .activated:
            print("WCSession is activated")
            
            
        case .inactive:
            print("WCSession is inactive")
        case .notActivated:
            print("WCSession is not activated")
        default:
            print("WCSession is in an unknown state")
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ niSession: WCSession) {
        
    }

    func sessionDidDeactivate(_ niSession: WCSession) {
        
    }
    
    func sessionWatchStateDidChange(_ niSession: WCSession) {
//        print("""
//            WCSession watch state did change:
//              - isPaired: \(niSession.isPaired)
//              - isWatchAppInstalled: \(niSession.isWatchAppInstalled)
//            """)
    }
    #endif
}
