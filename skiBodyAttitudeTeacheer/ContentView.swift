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
let xArbitCoreMotion = CMMotionManager()
let headphoneMotion = CMHeadphoneMotionManager()
let batchedSensorManager = CMBatchedSensorManager()
let motionWriter = MotionWriter()
struct CoreMotionWithTimeStamp :CoreMotionWithTimeStampProtocol{
    let deveceMotion: CMDeviceMotion
    
    let timeStampSince1970: TimeInterval
}



struct ContentView: View {
    
    @State var massOrSKi = true
    @StateObject var messageManager: MessageManager
    @StateObject var turnManager: TurnCoMManager
    @StateObject var motionAnalyzerManager :MotionAnalyzerManager
    @StateObject var healthCareManager: HealthCareManager = HealthCareManager()
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
    @State var currentAttitudePoint3d = Point3D.zero
    @State var currentAccel : Vector3D = Vector3D.forward
    @State var skiVelocityToTop: Double = 0
    var currentVelocity = CurrentVelocity.init(initalSpeed: 0)
    var body: some View {
        VStack{
            Rectangle().fill(.red).frame(width: (200 * currentAccel.x) + 200, height: 10)
            Rectangle().fill(.blue).frame(width: (200 * currentAccel.y) + 200, height: 10)
            Rectangle().fill(.brown).frame(width: (200 * currentAccel.z) + 200, height: 10)
            Text(String(currentAccel.x))
            Text(String(currentAccel.y))
            Text(String(currentAccel.z))
            HStack {
                Text(String(Int(healthCareManager.heartRate ?? 0)) )
                Button(" get hear rate"){
                    healthCareManager.get()
                }
                Text(String(messageManager.connectedPeers.first?.displayName ?? "no"))
                if let dir = turnManager.inclineCoM {
                    Text(dir.fallLineForwardGravityAbsoluteCenterOfMass.realPoint3DByCentimeter)
                    Text("cuurent attitude by point3d")
//                    Text(dir.skiDirectionAbsoluteByNorth.axis.description)
                }
                
            }
            HStack {
                Button("umb start") {
                    messageManager.sendDiscoveryToken()
                }
                Button("umb restart") {
                    messageManager.restartNISession()
                }
                if messageManager.isConnected {
                    if let distance : Double = messageManager.umbMeasuredData?.distance.converted(to: .centimeters).value {
                        Text("\(Int(round(distance)) )cm")
                    } else {
                        Text("-")
                    }
                    if let dirction = messageManager.umbMeasuredData?.realDistance.realPoint3DByCentimeter {
                        Text(dirction)
                    }
                } else {
                    Text("not connected")
                }
            }
            
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
            
            HStack{
                Button(action: {MotionAnalyzerManager.shared.turnSwitchingBeep = true}) {
                    Text("turn switching beep start ")
                }
                Button(action: {MotionAnalyzerManager.shared.turnSwitchingBeep = false}) {
                    Text("turn switching beep stop")
                }
            }
            HStack{
                Button(action: {MotionAnalyzerManager.shared.isターン切替時の減衰率の音声通知 = true}) {
                    Text("ターン切替時の減衰率の音声通知 start ")
                }
                Button(action: {MotionAnalyzerManager.shared.isターン切替時の減衰率の音声通知 = false}) {
                    Text("ターン切替時の減衰率の音声通知  stop")
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
                
                    if let inclineCoM = turnManager.inclineCoM{
                        HStack{
                        Text("true north attitude ")
                        Text("⇑")
                                .background(Color.blue)
                                .font(.largeTitle)
                                .rotationEffect(Angle.init(radians: (inclineCoM.skiDirectionAbsoluteByNorth.eulerAngles(order: .xyz).angles.x)))
                        Text("⇑")
                                .background(Color.blue)
                                .font(.largeTitle)
                                .rotationEffect(Angle.init(radians: (inclineCoM.skiDirectionAbsoluteByNorth.eulerAngles(order: .xyz).angles.y)))
                        Text("⇑")
                                .background(Color.blue)
                                .font(.largeTitle)
                                .rotationEffect(Angle.init(radians: (inclineCoM.skiDirectionAbsoluteByNorth.eulerAngles(order: .xyz).angles.z)))
                        }
                    }
                
                
                
                
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
                Text("current velocity to ski top " + String(round(skiVelocityToTop * 1000)))
            
            }
        }
    }
    private func motinoCalc(deviceMotion: CMDeviceMotion){
        currentAccel = Vector3D(vector: simd_double3(
            deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y,
            deviceMotion.userAcceleration.z ))
        
        let skiTurnPhase :SkiTurnPhase =
        MotionAnalyzerManager.shared.receiveBoardMotion(deviceMotion,
                                                        ProcessInfo
            .processInfo.systemUptime
        )
        skiVelocityToTop = skiTurnPhase.currentVelocityToSkiTop
        if let measuredData: UMBMeasuredData = messageManager.umbMeasuredData {
            turnManager.receive(coreMotion: deviceMotion, startedTime: ProcessInfo
                .processInfo.systemUptime, fallLineDirectionGravityAbsoluteByNorth:
                                    Rotation3D(skiTurnPhase.absoluteFallLineAttitude),
                                centerOfMassRelativeDirectionFromSki: measuredData.realDistance
            )
        }
    }
    func startRecord(){
        let fm = FileManager.default
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                //let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = documentsPath + "/myfile.txt"
                if !fm.fileExists(atPath: filePath) {
                    fm.createFile(atPath: filePath, contents: nil, attributes: [:])
                }
        if batchedSensorManager.isDeviceMotionActive {
            batchedSensorManager.startDeviceMotionUpdates{
                (motion, error) in
                if let deviceMotionList: [CMDeviceMotion] = motion {
                    for deviceMotion in deviceMotionList{
                        motinoCalc(deviceMotion: deviceMotion)
                    }
                }
            }
        } else {
            motionWriter.open(MotionWriter.makeFilePath(fileAlias: "motionRecord"))
            coreMotion.startDeviceMotionUpdates(
                using: .xTrueNorthZVertical,
                to: .current!) { (motion, error) in
                    if let deviceMotion: CMDeviceMotion = motion {
                        motinoCalc(deviceMotion: deviceMotion)
                        motionWriter.write(deviceMotion)
                    }
                    if let deviceMotioon: CMDeviceMotion = motion , let measuredData: UMBMeasuredData = messageManager.umbMeasuredData {
                        currentAttitude = Attitude.init(roll: motion!.attitude.roll, yaw: motion!.attitude.yaw, pitch: motion!.attitude.pitch)
                        //                    simd_quatf.init(ix: Float(motion!.attitude.quaternion.x),
                        //                                                   iy: Float(motion!.attitude.quaternion.y),
                        //                                                   iz: Float(motion!.attitude.quaternion.z),
                        //                                                   r: Float(motion!.attitude.quaternion.w))
                        if MotionAnalyzerManager.shared.磁北偏差 == nil{
                            MotionAnalyzerManager.shared.磁北偏差 = motion!.attitude.yaw
                        }
                        
                        idealDiffrencialConductor.data.detuningOffset = 440
                        
                        //                            turnYawingSide = skiTurnPhase.turnYawingSide
                        //                            idealDiffrencial = skiTurnPhase.yawingDiffrencialFromIdealYaw
                        //                            orthogonalAttitude = skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.attitude
                        //                            absoluteFallLineAttitude = skiTurnPhase.fallLineAttitude
                        //                            turnPhaseBy100 = skiTurnPhase.turnPhaseBy100
                        //                            turnPhaseByTime = skiTurnPhase.turnPhasePercentageByTime
                        //                            if(-0.08726646259971647..<0.08726646259971647 ~= skiTurnPhase.yawingDiffrencialFromIdealYaw
                        //                            ) {
                        //                                idealDiffrencialConductor.changeWaveFormToSquare()
                        //                            } else if (skiTurnPhase.yawingDiffrencialFromIdealYaw.sign == .plus){
                        //                                idealDiffrencialConductor.changeWaveFormToSin()
                        //                            } else{
                        //                                idealDiffrencialConductor.changeWaveFormToTriangle()
                        //                            }
                        //                            idealDiffrencialConductor.data.frequency = AUValue(ToneStep.hight(
                        //                                abs(ceil(Float(Measurement(value: skiTurnPhase.yawingDiffrencialFromIdealYaw, unit: UnitAngle.radians)
                        //                                    .converted(to: .degrees).value)))))
                        conductor.data.frequency = AUValue(ToneStep.hight(
                            abs(ceil(Float(Measurement(value: motion!.attitude.roll, unit: UnitAngle.radians)
                                .converted(to: .degrees).value)))))
                    }
                }
//            headphoneMotion.startDeviceMotionUpdates(to: .main) { (motion, error) in
//                headPhoneMotionDeviceLeft = Attitude.init(roll: 0, yaw: motion!.attitude.yaw + MotionAnalyzerManager.shared.磁北偏差!, pitch: 0)
//            }
        }
    }
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        headphoneMotion.stopDeviceMotionUpdates()
        motionWriter.close()
        MotionAnalyzerManager.shared.boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.turnPhaseAnalyzer.beforeSkiTurnPhase = nil
    }
    

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(messageManager: MessageManager(),turnManager: TurnManager())
//    }
//}
}



