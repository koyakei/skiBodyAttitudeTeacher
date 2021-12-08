//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
import simd
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
    @State var currentAttitude: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var yawingPeriod: Double = 0
    @State var accuracy: CMMagneticFieldCalibrationAccuracy = CMMagneticFieldCalibrationAccuracy.high
    @State var motionDate: Date = Date.now
    @State var turnChronologicalPhase:TurnChronologicalPhase = TurnChronologicalPhase.TurnMax
    @State var orthogonalAttitude : Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var barLength : CGFloat = 0
    @State var barLengthR : CGFloat = 0
    @State var barLengthX : CGFloat = 0
    @State var barLengthZ : CGFloat = 0
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
                HStack{
                Text("fall Line")
                Text("⇑")
                    .background(Color.red)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians:
                                                (absoluteFallLineAttitude.yaw - currentAttitude.yaw ) * -1) )}
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
                Text("yawing side " + turnYawingSide.rawValue)
                Text(turnChronologicalPhase.rawValue)
                Text(turnSwitchingDirection.rawValue)
                Text(motionDate.formatted(.dateTime.second().minute()))
                Text(Date.now.formatted(.dateTime.second().minute()))
            }
        }
        Rectangle()
            .fill(Color.blue)
            .frame(width: barLength + 150, height: 10)
        Rectangle()
                .fill(Color.red)
                .frame(width: barLengthR + 150, height: 10)
        Rectangle()
                .fill(Color.red)
                .frame(width: barLengthX + 150, height: 10)

        Rectangle()
                .fill(Color.yellow)
                .frame(width: barLengthZ + 150, height: 10)
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
        coreMotion.startDeviceMotionUpdates(
                using: .xTrueNorthZVertical,
                to: .current!) { (motion, error) in
                    currentAttitude = Attitude.init(roll: motion!.attitude.roll, yaw: motion!.attitude.yaw, pitch: motion!.attitude.pitch)
                    
            let cq = simd_quatd(
                    ix: motion!.attitude.quaternion.x,
                    iy: motion!.attitude.quaternion.y,
                    iz: motion!.attitude.quaternion.z,
                    r: motion!.attitude.quaternion.w
            )
                                        barLength =
                    simd_dot(
                        simd_normalize(simd_axis(cq *
                                                 simd_inverse(cq) *
                                                 simd_quatd( //　内への加速でプラスになっている
                                                    angle: Measurement(value: Double(turnYawingSide.shiftAngle()), unit: UnitAngle.degrees)
                                              .converted(to: .radians).value,
                                      axis: simd_double3(1 , 0 ,0))
                                                ) )
                        ,
                        simd_double3(motion!.userAcceleration.x, motion!.userAcceleration.y,
                                     motion!.userAcceleration.z)
                    ) * 100
                    
//                    AccelerationForTargetAngle.getAcceleration(userAcceleration: motion!.userAcceleration,                                                        userAttitude: cq - cq, targetAttitude:
//                                                                cq - cq
////                                                                simd_normalize(cq * AngleShifter.yawRotation(0))
//                    )
                    let date : Date = Date()
                    let calendar : Calendar = NSCalendar.current
                    let components : DateComponents = calendar.dateComponents([.nanosecond], from: date)
                    let nanoSeconds: Int = components.nanosecond ?? 0
                    let millSeconds = Int(nanoSeconds / 100000)
                    if millSeconds % 10 == 0 {
//                        SineWave.shared
//
//            SineWave.shared.hz = Float(abs(Measurement(value: motion!.attitude.roll, unit: UnitAngle.radians)
//                                                    .converted(to: .degrees).value) * 100.0)
//                        SineWave.shared.play()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        SineWave.shared.pause()
//                    }
                    }
            motionDate = Date(timeIntervalSince1970: CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion!.timestamp, systemUptime: ProcessInfo.processInfo.systemUptime))
            if MotionAnalyzerManager.shared.磁北偏差 == nil{
                MotionAnalyzerManager.shared.磁北偏差 = motion!.attitude.yaw
            }
                    
            let skiTurnPhase :SkiTurnPhase = MotionAnalyzerManager.shared.receiveBoardMotion(motion!,
                                         ProcessInfo
                                                 .processInfo.systemUptime
                                         )
                    orthogonalAttitude = skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.attitude
                    absoluteFallLineAttitude = skiTurnPhase.fallLineAttitude
            turnYawingSide = skiTurnPhase.turnYawingSide
            turnChronologicalPhase = skiTurnPhase.turnPhase
            turnSwitchingDirection = skiTurnPhase.turnSwitchingDirection

                    barLengthR = skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.targetDirectionAcceleration * 100
                    barLengthZ = skiTurnPhase.fallLineAcceleration * 300
//            headPhoneMotionDeviceLeft = QuaternionToEuler.init(q:skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.relativeAttitude / simd_quatd(
//                    ix: motion!.attitude.quaternion.x,
//                    iy: motion!.attitude.quaternion.y,
//                    iz: motion!.attitude.quaternion.z,
//                    r: motion!.attitude.quaternion.w
//            )).handle()
                }
        
        // 磁北が取れないのでどうするか？　どこかでキャリブレーションしないとね。
//        headphoneMotion.startDeviceMotionUpdates(to: .main) { (motion, error) in
//
//            let v:CenterOfMassTurnPhase? = MotionAnalyzerManager.shared.receiveAirPodMotion(motion!,
//                                         ProcessInfo
//                                                 .processInfo.systemUptime
//            )
//            headPhoneMotionDeviceLeft = Attitude.init(roll: 0, yaw: motion!.attitude.yaw + MotionAnalyzerManager.shared.磁北偏差!, pitch: 0)
        }
   
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        headphoneMotion.stopDeviceMotionUpdates()
        SineWave.shared.pause()
//        let myUnit = ToneOutputUnit()
//        myUnit.setFrequency(freq: 440)
//                                abs(Double(Measurement(value: motion!.attitude.roll, unit: UnitAngle.radians)
//                                                     .converted(to: .degrees).value) * 10))
//        myUnit.setToneVolume(vol: 0.5)
//        myUnit.enableSpeaker()
//        myUnit.setToneTime(t:100)
        
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

