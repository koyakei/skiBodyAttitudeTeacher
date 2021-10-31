//
//  ContentView.swift
//  skiBodyAttitudeTeacheer WatchKit Extension
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
import WatchKit

var connector = PhoneConnector()
let motionManager = CMMotionManager()
struct ContentView: View {
    var session: WKExtendedRuntimeSession = WKExtendedRuntimeSession()
    var body: some View {
        VStack{
        Button(action: {
            session.delegate = RecordController()
            session.start()
        }
        ){
            Text("start")
        }
            Button(action: {
                let session = RecordController()
                session.stopSession()
                
            }){
            Text("stop")
        }
        HStack {
                Text("\(connector.count)")
            }
            Text("\(connector.receivedMessage)")
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
