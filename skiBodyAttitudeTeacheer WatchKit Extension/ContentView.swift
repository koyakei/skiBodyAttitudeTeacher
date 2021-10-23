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
    var body: some View {
        VStack{
        Button(action: start){
            Text("start")
        }
        Button(action: stop){
            Text("stop")
        }
        }
        
    }
}

func start(){
    
    motionWriter.open(filename)
    motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
        if let motion = motion {
            motionWriter.write(motion)
        }
    }
}

func stop(){
    motionManager.stopDeviceMotionUpdates()
    motionWriter.close()
    let savedFile: Data?
    do{
     savedFile = try Data(contentsOf: filename)
    }catch {
        savedFile = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
