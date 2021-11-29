//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
//let motionWriter = MotionWriter()
//let motionWriterHeadPhone = MotionWriter()
//let motionWriterWatch = WatchMotionWriter()
let coreMotion = CMMotionManager()
let headphoneMotion = CMHeadphoneMotionManager()
import AVFoundation
import AudioToolbox
struct ContentView: View {
    @State var turnYawingSide: TurnYawingSide = TurnYawingSide.Straight
    @State var turnSwitchingDirection : TurnSwitchingDirection = TurnSwitchingDirection.Keep
    @State var absoluteFallLineAttitude :Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var currentYaw: Double = 0
    @State var yawingPeriod: Double = 0
    @State var accuracy: CMMagneticFieldCalibrationAccuracy = CMMagneticFieldCalibrationAccuracy.high
    @State var motionDate: Date = Date.now
    @State var turnChronologicalPhase:TurnChronologicalPhase = TurnChronologicalPhase.TurnMax
    @State var targetDirectionAccelerationAndRelativeAttitude : TargetDirectionAccelerationAndRelativeAttitude =
            TargetDirectionAccelerationAndRelativeAttitude.init(targetDirectionAcceleration: 0, relativeAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0))
    @State var barLength : CGFloat = 0
    @State var headPhoneMotionDeviceLeft: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var headPhoneMotionDeviceRight: CMDeviceMotion?
    var body: some View {
        
        VStack{
            
            Button(action: startRecord) {
                Text("Start")
            }
            Button(action: stopRecord) {
                Text("Stop")
            }
            VStack {
                Text("⇑")
                    .background(Color.red)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians:
                                               ((absoluteFallLineAttitude.yaw  - currentYaw) * -1)  ))
                Text("⇑")
                    .background(Color.blue)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: Double.pi / 2))
                Text("⇑")
                    .background(Color.green)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: targetDirectionAccelerationAndRelativeAttitude.relativeAttitude.yaw * -1 ))
                Divider()
                Text("yawing side" + turnYawingSide.rawValue)
                Text(turnChronologicalPhase.rawValue)
                Text(turnSwitchingDirection.rawValue)
                Text("\(yawingPeriod)")
                Text(motionDate.formatted(.dateTime.second().minute()))
                Text(Date.now.formatted(.dateTime.second().minute()))
            }
        }.onAppear{
            NSLog("Motion Available: \(headphoneMotion.isDeviceMotionAvailable)")
            NSLog("Motion Act: \(headphoneMotion.isDeviceMotionActive)")
        }
//        Rectangle()
//            .fill(Color.blue)
//            .frame(width: barLength + 100, height: 150)
        Text("⇑")
            .background(Color.green)
            .font(.largeTitle)
            .rotationEffect(Angle.init(radians: headPhoneMotionDeviceLeft.yaw))
        Text("⇑")
            .background(Color.green)
            .font(.largeTitle)
            .rotationEffect(Angle.init(radians: headPhoneMotionDeviceRight?.attitude.yaw ?? 0))
    }

    func startRecord(){
        coreMotion.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .current!) { (motion, error) in
            currentYaw = motion!.attitude.yaw
            motionDate = Date(timeIntervalSince1970: CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion!.timestamp, systemUptime: ProcessInfo.processInfo.systemUptime))
            if MotionAnalyzerManager.shared.磁北偏差 == nil{
                MotionAnalyzerManager.shared.磁北偏差 = motion!.attitude.yaw
            }
            let skiTurnPhase :SkiTurnPhase = MotionAnalyzerManager.shared.receiveBoardMotion(motion!,
                                         ProcessInfo
                                                 .processInfo.systemUptime
                                         )
            absoluteFallLineAttitude = skiTurnPhase.absoluteFallLineAttitude
            targetDirectionAccelerationAndRelativeAttitude = skiTurnPhase.orthogonalAccelerationAndRelativeAttitude
            turnYawingSide = skiTurnPhase.turnYawingSide
            turnChronologicalPhase = skiTurnPhase.turnPhase
            turnSwitchingDirection = skiTurnPhase.turnSwitchingDirection
            yawingPeriod = skiTurnPhase.turnSideChangePeriod
            barLength = CGFloat(targetDirectionAccelerationAndRelativeAttitude.targetDirectionAcceleration * 300)
        }
        // 磁北が取れないのでどうするか？　どこかでキャリブレーションしないとね。
//        headphoneMotion.startDeviceMotionUpdates(to: .main) { (motion, error) in
//
//            let v:CenterOfMassTurnPhase? = MotionAnalyzerManager.shared.receiveAirPodMotion(motion!,
//                                         ProcessInfo
//                                                 .processInfo.systemUptime
//            )
//            headPhoneMotionDeviceLeft = Attitude.init(roll: 0, yaw: motion!.attitude.yaw + MotionAnalyzerManager.shared.磁北偏差!, pitch: 0)
//        }
    }
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        headphoneMotion.stopDeviceMotionUpdates()
//        motionWriter.close()
//        motionWriterHeadPhone.close()
//        motionWriterWatch.close()
//        sensorKitManager.stopRecording()

    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
