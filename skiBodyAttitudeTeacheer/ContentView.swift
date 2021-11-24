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
// can only fetch data > 24 hours ago - //https://developer.apple.com/documentation/sensorkit/srfetchrequest

struct ContentView: View {
    @State var turnYawingSide: TurnYawingSide = TurnYawingSide.Straight
    @State var turnSwitchingDirection : TurnSwitchingDirection = TurnSwitchingDirection.Keep
    @State var attitude :Attitude = Attitude.init(roll: 0, yaw: 0, pitch: 0)
    @State var currentYaw: Double = 0
    @State var yawingPeriod: Double = 0
    @State var accuracy: CMMagneticFieldCalibrationAccuracy = CMMagneticFieldCalibrationAccuracy.high
    @State var motionDate: Date = Date.now
    var body: some View {
        
        VStack{
            
            Button(action: startRecord) {
                Text("Start")
            }
            Button(action: stopRecord) {
                Text("Stop")
            }
            VStack {
//                Text("⇑")
//                    .background(Color.red)
//                    .font(.largeTitle)
//                    .rotationEffect(Angle.init(radians: attitude.yaw ))
//                Text("⇑")
//                    .background(Color.blue)
//                    .font(.largeTitle)
//                    .rotationEffect(Angle.init(radians: attitude.roll ))
//                Text("⇑")
//                    .background(Color.green)
//                    .font(.largeTitle)
//                    .rotationEffect(Angle.init(radians: attitude.pitch ))
                Divider()
                Divider()
                Text(turnYawingSide.rawValue)
                Text(turnSwitchingDirection.rawValue)
                Text("\(yawingPeriod)")
                Text(motionDate.formatted(.dateTime.second().minute()))
                Text(Date.now.formatted(.dateTime.second().minute()))
            }
            
            
        }
    }

    func startRecord(){
        
//        motionWriter.open(MotionWriter.makeFilePath(fileAlias: "Body"))
//        motionWriterHeadPhone.open(MotionWriter.makeFilePath(fileAlias: "HeadPhone"))
        coreMotion.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .current!) { (motion, error) in
//            motionWriter.write(motion!)
            attitude = Attitude.init(roll: motion!.attitude.roll, yaw: motion!.attitude.yaw, pitch: motion!.attitude.pitch)
            motionDate = Date(timeIntervalSince1970: CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion!.timestamp, systemUptime: ProcessInfo.processInfo.systemUptime))
            (self.turnYawingSide, self.turnSwitchingDirection, _, self.yawingPeriod, motionDate) = MotionAnalyzerManager.shared.receiveBoardMotion(motion!,
                                         ProcessInfo
                                                 .processInfo.systemUptime
                                         )
        }
//        headphoneMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
//            motionWriterHeadPhone.write(motion!)
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
