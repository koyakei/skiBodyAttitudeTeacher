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
    @State var lastTurnMaxAttitude : CMAttitude? = nil
    @State var currentUserAccelalaration: CMAcceleration? = nil
    @State var outsideAccelaration: CMAcceleration? = nil
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
                    .rotationEffect(Angle.init(radians: (absoluteFallLineAttitude.yaw - currentYaw) ))
                Text("⇑")
                    .background(Color.blue)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: (absoluteFallLineAttitude.yaw)))
                Text("⇑")
                    .background(Color.green)
                    .font(.largeTitle)
                    .rotationEffect(Angle.init(radians: targetDirectionAccelerationAndRelativeAttitude.relativeAttitude.yaw ))
                Divider()
                Text("yawing side" + turnYawingSide.rawValue)
                Text(turnChronologicalPhase.rawValue)
                Text(turnSwitchingDirection.rawValue)
                Text("\(yawingPeriod)")
                Text(motionDate.formatted(.dateTime.second().minute()))
                Text(Date.now.formatted(.dateTime.second().minute()))
            }
            VStack{
//                Text("\(currentUserAccelalaration?.z)")
//                Text("\(outsideAccelaration?.z)")
            }
            
            
        }
    }

    func startRecord(){
        
//        motionWriter.open(MotionWriter.makeFilePath(fileAlias: "Body"))
//        motionWriterHeadPhone.open(MotionWriter.makeFilePath(fileAlias: "HeadPhone"))
        coreMotion.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .current!) { (motion, error) in
//            motionWriter.write(motion!)
//            motion!.attitude.multiply(byInverseOf: <#T##CMAttitude#>)
            currentYaw = motion!.attitude.yaw
            motionDate = Date(timeIntervalSince1970: CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion!.timestamp, systemUptime: ProcessInfo.processInfo.systemUptime))
            (self.turnYawingSide, self.turnSwitchingDirection, self.absoluteFallLineAttitude, self.yawingPeriod, turnChronologicalPhase ,targetDirectionAccelerationAndRelativeAttitude,motionDate) = MotionAnalyzerManager.shared.receiveBoardMotion(motion!,
                                         ProcessInfo
                                                 .processInfo.systemUptime
                                         )
            if nil == lastTurnMaxAttitude{
                lastTurnMaxAttitude = motion!.attitude
            }
            currentUserAccelalaration = motion!.userAcceleration
            print(currentUserAccelalaration?.y)
            if lastTurnMaxAttitude != nil{
            motion!.attitude.multiply(byInverseOf: lastTurnMaxAttitude!)
            outsideAccelaration = motion!.userAcceleration
                print ("di")
            print(outsideAccelaration?.y)
            }
        }
//        headphoneMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
//            MotionAnalyzerManager.shared.receiveAirPodMotion(motion!,
//                                         ProcessInfo
//                                                 .processInfo.systemUptime
//            )
//        }
        
//        sensorKitManager.request()
//        sensorKitManager.fetch() // 10ms ごとにフェッチ
//        motionWriterWatch.open(MotionWriter.makeFilePath(fileAlias: "Watch"))
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
