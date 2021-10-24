//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
let motionWriter = MotionWriter()
let coreMotion = CMMotionManager()
struct ContentView: View {
    var body: some View {
        VStack{
            Button(action: startRecord) {
                Text("Start")
            }
            Button(action: stopRecord) {
                Text("Stop")
            }
    }
}

    func startRecord(){
        motionWriter.open(MotionWriter.makeFilePath())
        coreMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            motionWriter.write(motion!)
        }
    }
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        motionWriter.close()
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
