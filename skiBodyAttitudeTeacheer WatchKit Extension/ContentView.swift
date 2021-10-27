//
//  ContentView.swift
//  skiBodyAttitudeTeacheer WatchKit Extension
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion


let motionManager = CMMotionManager()
let motionWriter = MotionWriter()
let filename = MotionWriter.makeFilePath()
struct ContentView: View {
    @ObservedObject var connector = PhoneConnector()
    var body: some View {
        VStack{
        Button(action: {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
                if let motion = motion {
                    connector.send(motion: motion)
                }
            }
        }){
            Text("start")
        }
        Button(action: stop){
            Text("stop")
        }
        HStack {
                Text("\(connector.count)")
            }
            Text("\(self.connector.receivedMessage)")
        }
        
    }
}
func stop(){
    motionManager.stopDeviceMotionUpdates()
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
