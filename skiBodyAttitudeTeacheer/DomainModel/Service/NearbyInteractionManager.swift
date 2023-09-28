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

//class NearbyInteractionManager: NSObject, ObservableObject {
//    
//    @Published var umbMeasuredData : UMBMeasuredData?{
//        
//        willSet{
//            // watch connectivity で送信する。
//            try? WCSession.default.updateApplicationContext([Helper.ridersDataKey: umbMeasuredData])
//        }
//    }
//    let messageManager : MessageManager
//    
//    private var didSendDiscoveryToken: Bool = false
//    
//    var isConnected: Bool {
//        return umbMeasuredData != nil
//    }
//    
//    private var niSession: NISession?
//    
//    init(messageManager: MessageManager) {
//        self.messageManager = messageManager
//        super.init()
//        initializeNISession()
//    }
//    
//    private func initializeNISession() {
//        print("initializing the NISession")
//        niSession = NISession()
//        niSession?.delegate = self
//        niSession?.delegateQueue = DispatchQueue.main
//    }
//    
//    private func deinitializeNISession() {
//        print("invalidating and deinitializing the NISession")
//        niSession?.invalidate()
//        niSession = nil
//        didSendDiscoveryToken = false
//    }
//    
//    private func restartNISession() {
//        print("restarting the NISession")
//        if let config = niSession?.configuration {
//            niSession?.run(config)
//        }
//    }
//    
//    /// Send the local discovery token to the paired device
//    func sendDiscoveryToken() {
//        guard let token = niSession?.discoveryToken else {
//            print("NIDiscoveryToken not available")
//            return
//        }
//        
//        guard let tokenData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
//            print("failed to encode NIDiscoveryToken")
//            return
//        }
//        messageManager.send(data: tokenData)
//        print("NIDiscoveryToken \(token) sent to counterpart")
//        didSendDiscoveryToken = true
//    }
//    
//    /// When a discovery token is received, run the session
//    func didReceiveDiscoveryToken(_ token: NIDiscoveryToken){
//        if niSession == nil { initializeNISession() }
//        if !didSendDiscoveryToken { sendDiscoveryToken() }
//        print("running NISession with peer token: \(token)")
//        niSession?.run(NINearbyPeerConfiguration(peerToken: token))
//    }
//}
//
//extension NearbyInteractionManager: NISessionDelegate {
//    
//    func sessionWasSuspended(_ session: NISession) {
//        print("NISession was suspended")
//        umbMeasuredData = nil
//    }
//    
//    func sessionSuspensionEnded(_ session: NISession) {
//        print("NISession suspension ended")
//        restartNISession()
//    }
//    
//    func session(_ session: NISession, didInvalidateWith error: Error) {
//        print("NISession did invalidate with error: \(error.localizedDescription)")
//        umbMeasuredData = nil
//    }
//    
//    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
//        for object in nearbyObjects {
//            if  let distance = object.distance , let direction = object.direction {
//                print("object distance: \(distance) meters")
//                self.umbMeasuredData = UMBMeasuredData(distance: Measurement(value: Double(distance), unit: .meters), direction: direction, timeStamp: Date.now.timeIntervalSince1970)
//                
//                
//            }
//        }
//    }
//    
//    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
//        switch reason {
//        case .peerEnded:
//            print("the remote peer ended the connection")
//            deinitializeNISession()
//        case .timeout:
//            print("peer connection timed out")
//            restartNISession()
//        default:
//            print("disconnected from peer for an unknown reason")
//        }
//        umbMeasuredData = nil
//    }
//}
