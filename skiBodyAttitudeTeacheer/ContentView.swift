//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//
import UIKit
import SwiftUI
import CoreMotion
import simd
import SceneKit
import NearbyInteraction
import MultipeerConnectivity
import Foundation
import AVFoundation
import AudioToolbox
import Spatial
let coreMotion = CMMotionManager()
let headphoneMotion = CMHeadphoneMotionManager()


struct CoreMotionWithTimeStamp :CoreMotionWithTimeStampProtocol{
    let deveceMotion: CMDeviceMotion
    
    let timeStampSince1970: TimeInterval
}


struct ContentView: View {
    
   
    
//    var nearbyInteractionManager : NearbyInteractionManager
//    var watchConnectionManager: WatchConnectionManager = WatchConnectionManager()
    @StateObject var messageManager: MessageManager
    
    
    @State var currentAngle : Float = 0
    @State var connectingTarget: String = "init"
    @State var absoluteFallLineAttitude :Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var currentAttitude: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var orthogonalAttitude : Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var headPhoneMotionDeviceLeft: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var lastSwitchedAngleRadian: Double = 0.0
    @State var turnPhaseBy100: Double = 0.0
    @State var idealDiffrencial: Double = 0.0
    @State var turnYawingSide: TurnYawingSide = TurnYawingSide.Straight
    @StateObject var conductor = DynamicOscillatorConductor()
    @StateObject var idealDiffrencialConductor = DynamicOscillatorConductor()
    @State var turnPhaseByTime: Double = 0.0
    @State private var isPresented: Bool = false
    @State private var messageText = ""
    @State private var receivedMessage = ""
    
    var body: some View {
        VStack{
            
            HStack {
                Text(String(messageManager.connectedPeers.first?.displayName ?? "no"))
                Text(messageManager.receivedMessage)
                            .padding()
                        
                        TextField("Enter a message", text: $messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("Send Message") {
                            messageManager.send(message: messageText)
                        }
                
                    }
            HStack{
//                Button("start adv"){
////                    messageManager.advertiserAssistant.startAdvertisingPeer()
////                    messageManager.mCNearbyServiceBrowser.startBrowsingForPeers()
//                    
//                }
//                Button("invite"){
//                    messageManager.invitePeer()
//                }
//                Button("startbrouse"){
//                    messageManager.mCNearbyServiceBrowser.startBrowsingForPeers()
////                    messageManager.advertiserAssistant.stopAdvertisingPeer()
////                    messageManager.mCNearbyServiceBrowser.stopBrowsingForPeers()
//                }
            }
            
//            HStack {
//                if nearbyInteractionManager.isConnected {
//                    if let distance = nearbyInteractionManager.umbMeasuredData?.distance.converted(to: .centimeters) {
//                        Text(distance.description + "cm")
//                        Text(nearbyInteractionManager.umbMeasuredData?.euler3d ?? "読めない" )
//                    } else {
//                        Text("-")
//                    }
//                } else {
//                    Text("not connected")
//                }
//            }
            
            HStack{
            Button(action: startRecord) {
                Text("Start motion ")
            }
            Button(action: stopRecord) {
                Text("Stop motion")
            }
            }
            
            HStack{
                Button(action: {
                    self.idealDiffrencialConductor.data.isPlaying.toggle()
                }) {
                    Text(self.conductor.data.isPlaying ? "yaw diffrencial tone　STOP" : "diff tone START")
                    
                }
            }.navigationBarTitle(Text("Dynamic Oscillator"))
                .onAppear {
                    self.idealDiffrencialConductor.start()
                }
                .onDisappear {
                    self.idealDiffrencialConductor.stop()
                }
            
            HStack{
                Button(action: {
                    self.conductor.data.isPlaying.toggle()
                }) {
                    Text(self.conductor.data.isPlaying ? "roll tone STOP" : "roll tone START")
                    
                }
            }.navigationBarTitle(Text("Dynamic Oscillator"))
                .onAppear {
                    self.conductor.start()
                }
                .onDisappear {
                    self.conductor.stop()
                }
            
            HStack{
                Button(action: {MotionAnalyzerManager.shared.turnMaxBeep = true}) {
                    Text("turn max beep start ")
                }
                Button(action: {MotionAnalyzerManager.shared.turnMaxBeep = false}) {
                    Text("turn max beep stop")
                }
            }
            HStack{
                Button(action: {MotionAnalyzerManager.shared.turn1to3Beep = true}) {
                    Text("turn 1/3 beep start ")
                }
                Button(action: {MotionAnalyzerManager.shared.turn1to3Beep = false}) {
                    Text("turn 1/3 beep stop")
                }
            }
            VStack {
                
                HStack{
                    Text("last switched DIrection")
                    Text("⇑")
                        .background(Color.red)
                        .font(.largeTitle)
                        .rotationEffect(Angle.init(radians:
                                                    (lastSwitchedAngleRadian - (currentAttitude.yaw * -1) )  ))
                Text("fall Line")
                Text("⇑")
                    .background(Color.red)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians:
                                                (absoluteFallLineAttitude.yaw - currentAttitude.yaw ) * -1) )
                    .overlay{
                        Text("↑")
                            .background(Color.clear)
                            .foregroundColor(Color.blue)
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .rotationEffect(Angle.init(radians:
                                                        (
                                                            (absoluteFallLineAttitude.yaw - currentAttitude.yaw ) * -1) +
                                                       (idealDiffrencial
                                                                                                                        * 2 * Double(turnYawingSide.turnsideToSign()
                                                                                                                                )
                                                       )
                                                      ) )
                    }
                
                }
                Text("ideal diff")
                HStack{
                    Text("orthogonal line to turn out")
                    Text("⇑")
                        .background(Color.green)
                        .font(.largeTitle)
                        .rotationEffect(Angle.init(radians: (orthogonalAttitude.yaw - currentAttitude.yaw) * -1 ))
                }
                Text("⇑")
                    .background(Color.blue)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: ((absoluteFallLineAttitude.yaw - currentAttitude.yaw ) * -1 ) + (.pi / 2 ) ) )

                Text("⇑")
                        .background(Color.red)
                        .font(.largeTitle)
                        .rotationEffect(Angle.init(radians:
                                                    (absoluteFallLineAttitude.pitch - currentAttitude.yaw) * -1 ))
                Text("⇑")
                        .background(Color.blue)
                        .font(.largeTitle)
                        .rotationEffect(Angle.init(radians: Double.pi / 2))
                
            }
            VStack{
                HStack{
                    Text("turn Phase " + String(
                        round(turnPhaseBy100 * 100 ))
                    )
                }
                        Text("yaw diff " + String(
                            round(Angle.init(radians:idealDiffrencial).degrees)
                        ))
                    
                    Text("by time turn phase " + String(
                                                round(
                                                    turnPhaseByTime * 100
                        //                            Angle.init(radians:idealDiffrencial).degrees
                                                     )
                    ))
                
                
            }
        }
    }
    
    func startRecord(){
        coreMotion.startDeviceMotionUpdates(
                using: .xArbitraryCorrectedZVertical,
                to: .current!) { (motion, error) in
            let skiTurnPhase :SkiTurnPhase = MotionAnalyzerManager.shared.receiveBoardMotion(motion!,
                                         ProcessInfo
                                                 .processInfo.systemUptime
                                         )
                    
                    currentAttitude = Attitude.init(roll: motion!.attitude.roll, yaw: motion!.attitude.yaw, pitch: motion!.attitude.pitch)
//                    simd_quatf.init(ix: Float(motion!.attitude.quaternion.x),
//                                                   iy: Float(motion!.attitude.quaternion.y),
//                                                   iz: Float(motion!.attitude.quaternion.z),
//                                                   r: Float(motion!.attitude.quaternion.w))
            if MotionAnalyzerManager.shared.磁北偏差 == nil{
                MotionAnalyzerManager.shared.磁北偏差 = motion!.attitude.yaw
            }
                    idealDiffrencialConductor.data.detuningOffset = 440
                    turnYawingSide = skiTurnPhase.turnYawingSide
                    idealDiffrencial = skiTurnPhase.yawingDiffrencialFromIdealYaw
                    orthogonalAttitude = skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.attitude
                    absoluteFallLineAttitude = skiTurnPhase.fallLineAttitude
                    turnPhaseBy100 = skiTurnPhase.turnPhaseBy100
                    turnPhaseByTime = skiTurnPhase.turnPhasePercentageByTime
                    if(-0.08726646259971647..<0.08726646259971647 ~= skiTurnPhase.yawingDiffrencialFromIdealYaw
                    ) {
                        idealDiffrencialConductor.changeWaveFormToSquare()
                    } else if (skiTurnPhase.yawingDiffrencialFromIdealYaw.sign == .plus){
                        idealDiffrencialConductor.changeWaveFormToSin()
                    } else{
                        idealDiffrencialConductor.changeWaveFormToTriangle()
                    }
                    idealDiffrencialConductor.data.frequency = AUValue(ToneStep.hight(
                        abs(ceil(Float(Measurement(value: skiTurnPhase.yawingDiffrencialFromIdealYaw, unit: UnitAngle.radians)
                                                                                    .converted(to: .degrees).value)))))
                    conductor.data.frequency = AUValue(ToneStep.hight(
                        abs(ceil(Float(Measurement(value: motion!.attitude.roll, unit: UnitAngle.radians)
                                                                                    .converted(to: .degrees).value)))))
                }
        headphoneMotion.startDeviceMotionUpdates(to: .main) { (motion, error) in
            headPhoneMotionDeviceLeft = Attitude.init(roll: 0, yaw: motion!.attitude.yaw + MotionAnalyzerManager.shared.磁北偏差!, pitch: 0)
        }
    }
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        headphoneMotion.stopDeviceMotionUpdates()
    }
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(messageManager: MessageManager())
    }
}
}



