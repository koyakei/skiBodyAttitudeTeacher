//
//  ConnectManager.swift
//  SkiWatch Watch App
//
//  Created by koyanagi on 2023/09/22.
//

import NearbyInteraction
import WatchConnectivity
import Combine
import os.log

class WatchSideConnectionManager: NSObject, ObservableObject {
    @Published var distance: Measurement<UnitLength>?
    @Published var direction: SIMD3<Float>?
    @Published var euler3d : String?
    
    var isConnected: Bool {
        return distance != nil
    }
    override init() {
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

extension WatchSideConnectionManager :WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard error == nil else {
            os_log("WCSession failed to activate: \(error!.localizedDescription)")
            return
        }
        
        switch activationState {
        case .activated:
            os_log("WCSession is activated")
        case .inactive:
            os_log("WCSession is inactive")
        case .notActivated:
            os_log("WCSession is not activated")
        default:
            os_log("WCSession is in an unknown state")
        }
    }
    
    func session(_ session: NISession, didUpdate objects: [UMBMeasuredData]) {
        for object in objects {
            direction = object.direction
            distance = object.distance
            euler3d = object.euler3d
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let ridersData = applicationContext[Helper.ridersDataKey] as? UMBMeasuredData {
            distance = ridersData.distance
            direction = ridersData.direction
            euler3d = ridersData.euler3d
        }
    }
}


class WatchSideNearbyInteractionManager: NSObject, ObservableObject {
    
    /// The distance to the nearby object (the paired device) in meters.
    @Published var distance: Measurement<UnitLength>?
    
    private var didSendDiscoveryToken: Bool = false
    
    var isConnected: Bool {
        return distance != nil
    }
    
    private var session: NISession?
    
    override init() {
        super.init()
        
        initializeNISession()
        
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    private func initializeNISession() {
        os_log("initializing the NISession")
        session = NISession()
        session?.delegate = self
        session?.delegateQueue = DispatchQueue.main
    }
    
    private func deinitializeNISession() {
        os_log("invalidating and deinitializing the NISession")
        session?.invalidate()
        session = nil
        didSendDiscoveryToken = false
    }
    
    private func restartNISession() {
        os_log("restarting the NISession")
        if let config = session?.configuration {
            session?.run(config)
        }
    }
    
    /// Send the local discovery token to the paired device
    private func sendDiscoveryToken() {
        guard let token = session?.discoveryToken else {
            os_log("NIDiscoveryToken not available")
            return
        }
        
        guard let tokenData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            os_log("failed to encode NIDiscoveryToken")
            return
        }
        
        do {
            try WCSession.default.updateApplicationContext([Helper.ridersDataKey: tokenData])
            os_log("NIDiscoveryToken \(token) sent to counterpart")
            didSendDiscoveryToken = true
        } catch let error {
            os_log("failed to send NIDiscoveryToken: \(error.localizedDescription)")
        }
    }
    
    /// When a discovery token is received, run the session
    private func didReceiveDiscoveryToken(_ token: NIDiscoveryToken) {

        if session == nil { initializeNISession() }
        if !didSendDiscoveryToken { sendDiscoveryToken() }
        
        os_log("running NISession with peer token: \(token)")
        let config = NINearbyPeerConfiguration(peerToken: token)
        session?.run(config)
    }
}

// MARK: - NISessionDelegate

extension WatchSideNearbyInteractionManager: NISessionDelegate {
    
    func sessionWasSuspended(_ session: NISession) {
        os_log("NISession was suspended")
        distance = nil
    }
    
    func sessionSuspensionEnded(_ session: NISession) {
        os_log("NISession suspension ended")
        restartNISession()
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        os_log("NISession did invalidate with error: \(error.localizedDescription)")
        distance = nil
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        if let object = nearbyObjects.first, let distance = object.distance {
            os_log("object distance: \(distance) meters")
            self.distance = Measurement(value: Double(distance), unit: .meters)
        }
    }
    

    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        switch reason {
        case .peerEnded:
            os_log("the remote peer ended the connection")
            deinitializeNISession()
        case .timeout:
            os_log("peer connection timed out")
            restartNISession()
        default:
            os_log("disconnected from peer for an unknown reason")
        }
        distance = nil
    }
}

// MARK: - WCSessionDelegate
extension WatchSideNearbyInteractionManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard error == nil else {
            os_log("WCSession failed to activate: \(error!.localizedDescription)")
            return
        }
        
        switch activationState {
        case .activated:
            os_log("WCSession is activated")
            if !didSendDiscoveryToken {
                sendDiscoveryToken()
            }
        case .inactive:
            os_log("WCSession is inactive")
        case .notActivated:
            os_log("WCSession is not activated")
        default:
            os_log("WCSession is in an unknown state")
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ niSession: WCSession) {
        os_log("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ niSession: WCSession) {
        os_log("WCSession did deactivate")
    }
    
    func sessionWatchStateDidChange(_ niSession: WCSession) {
        os_log("""
            WCSession watch state did change:
              - isPaired: \(niSession.isPaired)
              - isWatchAppInstalled: \(niSession.isWatchAppInstalled)
            """)
    }
    #endif
    
    
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let tokenData = applicationContext[Helper.ridersDataTokenKey] as? Data {
            if let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: tokenData) {
                os_log("received NIDiscoveryToken \(token) from counterpart")
                self.didReceiveDiscoveryToken(token)
            } else {
                os_log("failed to decode NIDiscoveryToken")
            }
        }
    }
}
