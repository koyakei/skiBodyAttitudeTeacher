/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The helper class that handles the transfer of discovery tokens between peers
         and maintains the Nearby Interaction session.
*/

import NearbyInteraction
import Combine
import os.log

class NearbyInteractionManager: NSObject, ObservableObject {
    
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

extension NearbyInteractionManager: NISessionDelegate {
    
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
