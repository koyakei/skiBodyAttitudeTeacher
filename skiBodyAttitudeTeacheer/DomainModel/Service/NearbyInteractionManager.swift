/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The helper class that handles the transfer of discovery tokens between peers
         and maintains the Nearby Interaction session.
*/

import NearbyInteraction
import Combine
import os.log
import MultipeerConnectivity
import WatchConnectivity

class NearbyInteractionManager: NSObject, ObservableObject {
    
    @Published var umbMeasuredData : UMBMeasuredData?{
        
        willSet{
            // watch connectivity で送信する。
            try? WCSession.default.updateApplicationContext([Helper.ridersDataKey: umbMeasuredData])
        }
    }
//    var messageManager = ContentView.messageManager
    
    private var didSendDiscoveryToken: Bool = false
    
    var isConnected: Bool {
        return umbMeasuredData != nil
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
        
        
//        messageManager.send(data: tokenData)
        os_log("NIDiscoveryToken \(token) sent to counterpart")
        didSendDiscoveryToken = true
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

extension NearbyInteractionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) {
            os_log("received NIDiscoveryToken \(token) from counterpart")
            self.didReceiveDiscoveryToken(token)
        } else {
            os_log("failed to decode NIDiscoveryToken")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
// MARK: - NISessionDelegate

extension NearbyInteractionManager: NISessionDelegate {
    
    func sessionWasSuspended(_ session: NISession) {
        os_log("NISession was suspended")
        umbMeasuredData = nil
    }
    
    func sessionSuspensionEnded(_ session: NISession) {
        os_log("NISession suspension ended")
        restartNISession()
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        os_log("NISession did invalidate with error: \(error.localizedDescription)")
        umbMeasuredData = nil
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        for object in nearbyObjects {
            if  let distance = object.distance , let direction = object.direction {
                os_log("object distance: \(distance) meters")
                self.umbMeasuredData = UMBMeasuredData(distance: Measurement(value: Double(distance), unit: .meters), direction: direction, timeStamp: Date.now.timeIntervalSince1970)
                
                
            }
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
        umbMeasuredData = nil
    }
}
