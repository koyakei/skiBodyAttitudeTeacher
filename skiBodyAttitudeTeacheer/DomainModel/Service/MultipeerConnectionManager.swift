import MultipeerConnectivity
import NearbyInteraction
import WatchConnectivity
extension MessageManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension MessageManager : MCSessionDelegate{
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.receivedMessage = message
            }
        }
        if let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) {
            print("received NIDiscoveryToken \(token) from counterpart")
            didReceiveDiscoveryToken(token)
        } else {
            print("failed to decode NIDiscoveryToken")
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        connectedPeers = session.connectedPeers
        switch state {
                case .connected:
                    print("Connected to peer: \(peerID.displayName)")
                    // 接続が確立されたときの処理を追加
                case .connecting:
                    print("Connecting to peer: \(peerID.displayName)")
                case .notConnected:
                    print("Disconnected from peer: \(peerID.displayName)")
                @unknown default:
                    fatalError("Unknown session state")
                }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("d")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("d")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("d")
    }
}

extension MessageManager : MCNearbyServiceBrowserDelegate{
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: "syotai".data(using: .utf8), timeout: 400)
        print(peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("")
    }
    
}

class MessageManager: NSObject, ObservableObject {
    
    @Published var umbMeasuredData : UMBMeasuredData?
//    {
//        
//        willSet{
//            // watch connectivity で送信する。
////            try? WCSession.default.updateApplicationContext([Helper.ridersDataKey: umbMeasuredData])
//        }
//    }
    
    private var didSendDiscoveryToken: Bool = false
    
    var isConnected: Bool {
        return umbMeasuredData != nil
    }
    
    private var niSession: NISession = NISession()
    
    private func initializeNISession() {
        
        niSession.delegate = self
        niSession.delegateQueue = DispatchQueue.main
        print("initializing the NISession")
    }
    
    private func deinitializeNISession() {
        print("invalidating and deinitializing the NISession")
        niSession.invalidate()
        didSendDiscoveryToken = false
    }
    
    func restartNISession() {
        print(niSession.configuration)
        if let config = niSession.configuration {
            niSession.run(config)
            print("restarting the NISession")
        }
    }
    
    /// Send the local discovery token to the paired device
    func sendDiscoveryToken() {
        guard let token = niSession.discoveryToken else {
            print("NIDiscoveryToken not available")
            return
        }
        
        guard let tokenData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            print("failed to encode NIDiscoveryToken")
            return
        }
        send(data: tokenData)
        didSendDiscoveryToken = true
        print("NIDiscoveryToken \(token) sent to counterpart")
        
    }
    
    /// When a discovery token is received, run the session
    func didReceiveDiscoveryToken(_ token: NIDiscoveryToken){
//        if niSession == nil { initializeNISession() }
        if !didSendDiscoveryToken { sendDiscoveryToken() }
        niSession.run(NINearbyPeerConfiguration(peerToken: token))
        print("running NISession with peer token: \(token)")
    }
    
    
    @Published var connectedPeers: [MCPeerID] = []
    let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    @Published  var session: MCSession
    private let serviceType = "your-service"
    private var advertiserAssistant: MCNearbyServiceAdvertiser!
    private var mCNearbyServiceBrowser : MCNearbyServiceBrowser!
    
    @Published var receivedMessage = ""
    
    func connectButtonTapped() {
            // サービスタイプを指定してMCBrowserViewControllerを作成
            
        }
    
    override init() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        session.delegate = self
        mCNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID,
                                                          serviceType: serviceType)
        mCNearbyServiceBrowser.delegate = self
        advertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiserAssistant.delegate = self
        mCNearbyServiceBrowser.startBrowsingForPeers()
        advertiserAssistant.startAdvertisingPeer()
        initializeNISession()
    }
    
    func send(message: String) {
        if session.connectedPeers.count > 0 {
            do {
                try session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
    
    func send(data: Data){
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
}


extension MessageManager: NISessionDelegate {
    
    func sessionWasSuspended(_ session: NISession) {
        print("NISession was suspended")
//        umbMeasuredData = nil
    }
    
    func sessionSuspensionEnded(_ session: NISession) {
        print("NISession suspension ended")
        restartNISession()
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        print("NISession did invalidate with error: \(error.localizedDescription)")
        umbMeasuredData = nil
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        print(nearbyObjects)
        for object in nearbyObjects {
            if  let distance = object.distance , let direction = object.direction {
                print("object distance: \(distance) meters")
                self.umbMeasuredData = UMBMeasuredData(distance: Measurement(value: Double(distance), unit: .meters), direction: direction, timeStamp: Date.now.timeIntervalSince1970)
            }
        }
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        switch reason {
        case .peerEnded:
            print("the remote peer ended the connection")
//            deinitializeNISession()
        case .timeout:
            print("peer connection timed out")
            restartNISession()
        default:
            print("disconnected from peer for an unknown reason")
        }
        umbMeasuredData = nil
    }
}
