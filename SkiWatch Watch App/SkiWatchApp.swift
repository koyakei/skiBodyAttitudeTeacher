//
//  SkiWatchApp.swift
//  SkiWatch Watch App
//
//  Created by koyanagi on 2023/09/20.
//

import SwiftUI
import WatchKit

@main
struct SkiWatch_Watch_AppApp: App {
    private var connectionManager: WatchSideConnectionManager?
    @State var distance: Measurement<UnitLength>?
    @State var direction: SIMD3<Float>?
        

    var body: some Scene {
        WindowGroup {
            if let connectionManager = connectionManager {
                ContentView(connectionManager: connectionManager)
                    .onReceive(connectionManager.$distance) {
                        self.distance = $0?.converted(to: Helper.localUnits)
                    }
                    .onReceive(connectionManager.$direction) {
                        self.direction = $0
                    }
            } else {
                Text("NearbyInteraction is not supported on this device")
            }

        }
    }
}
