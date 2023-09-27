//
//  ContentView.swift
//  SkiWatch Watch App
//
//  Created by koyanagi on 2023/09/20.
//

import SwiftUI
import Spatial

struct ContentView: View {
    @ObservedObject var connectionManager: WatchSideConnectionManager
    let connectionDirections = "Open the app on your phone to connect"
    var body: some View {
        VStack(spacing: 10) {
            if connectionManager.isConnected {
                if let distance = connectionManager.distance?.converted(to: Helper.localUnits) {
                    Text(Helper.localFormatter.string(from: distance)).font(.title)
                } else {
                    Text("-")
                }
                if let euler3d = connectionManager.euler3d {
                    Text(euler3d).font(.title)
                } else {
                    Text("-")
                }
            } else {
                Text(connectionDirections)
            }
        }

    }
}

#Preview {
    ContentView( connectionManager: WatchSideConnectionManager())
}
