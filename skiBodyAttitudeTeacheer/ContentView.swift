//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
let motionWriter = MotionWriter()
let motionWriterHeadPhone = MotionWriter()
let motionWriterWatch = MotionWriter()
let coreMotion = CMMotionManager()
let headphoneMotion = CMHeadphoneMotionManager()

struct ContentView: View {
    @ObservedObject var connector = WatchConnector()
    var body: some View {
        VStack{
            Button(action: startRecord) {
                Text("Start")
            }
            Button(action: stopRecord) {
                Text("Stop")
            }
            HStack {
                            Text("\(connector.count)")
                            Button(action: { self.connector.send() }) { Text("送信") }
                        }
                        Text("\(self.connector.receivedMessage)")
        }
    }

    func startRecord(){
        motionWriter.open(MotionWriter.makeFilePath(fileAlias: "Body"))
        motionWriterHeadPhone.open(MotionWriter.makeFilePath(fileAlias: "HeadPhone"))
        motionWriterWatch.open(MotionWriter.makeFilePath(fileAlias: "Watch"))
        coreMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            motionWriter.write(motion!)
        }
        headphoneMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            motionWriterHeadPhone.write(motion!)
        }
    }
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        headphoneMotion.stopDeviceMotionUpdates()
        motionWriter.close()
        motionWriterHeadPhone.close()
        motionWriterWatch.close()
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
