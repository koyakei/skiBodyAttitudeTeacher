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
    @State var targetDirectionAccelerationAndRelativeAttitude : Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var barLength : CGFloat = 0
    @State var barLengthR : CGFloat = 0
    @State var barLengthX : CGFloat = 0
    @State var barLengthZ : CGFloat = 0
    @State var headPhoneMotionDeviceLeft: Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var headPhoneMotionDeviceRight: CMDeviceMotion?
    @State var quoternion: CMQuaternion = CMQuaternion.init(x: 0, y: 0, z: 0, w: 0)

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
                                               ((absoluteFallLineAttitude.yaw  - currentAttitude.yaw) * -1)  ))
                Text("⇑")
                    .background(Color.blue)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: currentAttitude.yaw ) )
                Text("⇑")
                    .background(Color.green)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: (targetDirectionAccelerationAndRelativeAttitude.yaw - currentAttitude.yaw) * -1 ))
                Text("⇑")
                        .background(Color.red)
                        .font(.largeTitle)
                        .rotationEffect(Angle.init(radians:
                                                   headPhoneMotionDeviceLeft.yaw * -1))
//                Text("⇑")
//                        .background(Color.blue)
//                        .font(.largeTitle)
//                        .rotationEffect(Angle.init(radians: Double.pi / 2))
//                Text("⇑")
//                        .background(Color.green)
//                        .font(.largeTitle)
//                        .rotationEffect(Angle.init(radians: targetDirectionAccelerationAndRelativeAttitude.relativeAttitude.yaw * -1 ))
                Divider()
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
        SineWave.shared.hz = Float(440)
                    SineWave.shared.play()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    SineWave.shared.pause()
//                }
        coreMotion.startDeviceMotionUpdates(
                using: .xTrueNorthZVertical,
                to: .current!) { (motion, error) in


            let cq = simd_quatd(
                    ix: motion!.attitude.quaternion.x,
                    iy: motion!.attitude.quaternion.y,
                    iz: motion!.attitude.quaternion.z,
                    r: motion!.attitude.quaternion.w
            )
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
//            currentAttitude = QuaternionToEuler.init(q: cq ).handle()
//            quoternion = motion!.attitude.quaternion
//            motionDate = Date(timeIntervalSince1970: CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion!.timestamp, systemUptime: ProcessInfo.processInfo.systemUptime))
//            if MotionAnalyzerManager.shared.磁北偏差 == nil{
//                MotionAnalyzerManager.shared.磁北偏差 = motion!.attitude.yaw
//            }
                    
//            let skiTurnPhase :SkiTurnPhase = MotionAnalyzerManager.shared.receiveBoardMotion(motion!,
//                                         ProcessInfo
//                                                 .processInfo.systemUptime
//                                         )
//            absoluteFallLineAttitude =  QuaternionToEuler.init(q: skiTurnPhase.absoluteFallLineAttitude).handle()
//                    targetDirectionAccelerationAndRelativeAttitude = QuaternionToEuler.init(q: skiTurnPhase.orthogonalAccelerationAndRelativeAttitude.relativeAttitude).handle()
//            turnYawingSide = skiTurnPhase.turnYawingSide
//            turnChronologicalPhase = skiTurnPhase.turnPhase
//            turnSwitchingDirection = skiTurnPhase.turnSwitchingDirection
//                    let ac :simd_double3 = simd_axis(skiTurnPhase.absoluteFallLineAttitude
//                                       * simd_quatd(
//                            angle: Measurement(value: 90, unit: UnitAngle.degrees)
//                                    .converted(to: .radians).value,
//                            axis: simd_double3(0 , 1 ,0))
//
//                    ) * simd_double3(
//                                motion!.userAcceleration.x , motion!.userAcceleration.y
//                                ,motion!.userAcceleration.z)
//                    barLength = ac.x * 300
//                    barLengthR = ac.y * 300
//                    barLengthZ = skiTurnPhase.fallLineAcceleration * 300
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

