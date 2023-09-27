//
//  MessageManager.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/14.
//

import MultipeerConnectivity
import NearbyInteraction

extension MessageManager: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("invited")
        AlertView(showAlert: true, invitationHandler: invitationHandler, session: session, targetDevice: UIDevice.current.model)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("can not start")
    }
}



final class MessageManager: NSObject, ObservableObject{
    @Published var connectedPeers: [MCPeerID] = []
    var peerID: MCPeerID!
    var session: MCSession!
    private let serviceType = "your-service"
    var advertiserAssistant: MCNearbyServiceAdvertiser
    var mCNearbyServiceBrowser : MCNearbyServiceBrowser
    
    @Published var receivedMessage = ""
    var browserViewController: MCBrowserViewController?
    
    func invitePeer(){
//        (UIDevice.current.model + UIDevice.current.name).data(using: .utf8)
        mCNearbyServiceBrowser.invitePeer(
            peerID, to: session, withContext: nil, timeout: 600)
    }
    
    override init() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        
        mCNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID,
                                                          serviceType: serviceType)

        advertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)

        super.init()
        
        advertiserAssistant.delegate = self
        mCNearbyServiceBrowser.delegate = self
        session.delegate = self
//        mCNearbyServiceBrowser.startBrowsingForPeers()
//        advertiserAssistant.startAdvertisingPeer()
    }
    
    func send( data: Data){
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
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
    
    
    
    // 他の必要なMCSessionDelegateメソッドを実装することもできます。
}

extension MessageManager: MCSessionDelegate{
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

extension MessageManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("found")
        print(peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        print("lost")
        print(peerID.displayName)
    }
    
}

