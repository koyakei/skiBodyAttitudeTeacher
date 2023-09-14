//
//  MessageManager.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/14.
//

import MultipeerConnectivity

extension MessageManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
   
}

class MessageManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: "syotai".data(using: .utf8), timeout: 400)
        print(peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("")
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
    @Published var connectedPeers: [MCPeerID] = []
    private var peerID: MCPeerID!
    private var session: MCSession!
    private let serviceType = "your-service"
    private var advertiserAssistant: MCNearbyServiceAdvertiser!
    private var mCNearbyServiceBrowser : MCNearbyServiceBrowser!
    
    @Published var receivedMessage = ""
    var browserViewController: MCBrowserViewController?
    
    func connectButtonTapped() {
            // サービスタイプを指定してMCBrowserViewControllerを作成
            
        }
    
    override init() {
        super.init()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        mCNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID,
                                                          serviceType: serviceType)

        mCNearbyServiceBrowser.delegate = self
        advertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiserAssistant.delegate = self
            mCNearbyServiceBrowser.startBrowsingForPeers()
        
            advertiserAssistant.startAdvertisingPeer()
        
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
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.receivedMessage = message
            }
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
    
    // 他の必要なMCSessionDelegateメソッドを実装することもできます。
}
