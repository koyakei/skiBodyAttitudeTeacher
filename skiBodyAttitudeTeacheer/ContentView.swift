//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
import simd
import SceneKit

let coreMotion = CMMotionManager()
let headphoneMotion = CMHeadphoneMotionManager()

import AVFoundation
import AudioToolbox
struct ContentView: View {
    @State var absoluteFallLineAttitude :Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var currentAttitude: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var orthogonalAttitude : Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var headPhoneMotionDeviceLeft: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var lastSwitchedAngleRadian: Double = 0.0
    @State var turnPhaseBy100: Double = 0.0
    @State var idealDiffrencial: Double = 0.0
    @StateObject var conductor = DynamicOscillatorConductor()
    @StateObject var idealDiffrencialConductor = DynamicOscillatorConductor()

    var body: some View {
        VStack{
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
                    Text(self.conductor.data.isPlaying ? "diffrencial toneSTOP" : "diff tone START")
                    
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
                    Text("last switching")
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
                
                Text("ideal diff")
                Text("⇑")
                    .background(Color.red)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians:
                                                (absoluteFallLineAttitude.yaw - currentAttitude.yaw ) * -1 + idealDiffrencial) )}
            
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
            }
        }
    }
    
    func startRecord(){
        coreMotion.startDeviceMotionUpdates(
                using: .xTrueNorthZVertical,
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
                    idealDiffrencial = skiTurnPhase.yawingDiffrencialFromIdealYaw
                    orthogonalAttitude = skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.attitude
                    absoluteFallLineAttitude = skiTurnPhase.fallLineAttitude
                    turnPhaseBy100 = skiTurnPhase.turnPhaseBy100
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
        ContentView()
    }
}
}
