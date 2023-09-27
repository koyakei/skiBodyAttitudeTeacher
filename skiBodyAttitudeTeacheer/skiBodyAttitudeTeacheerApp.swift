//
//  skiBodyAttitudeTeacheerApp.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI

@main
struct SkiBodyAttitudeTeacheerApp: App {
    var messageManager = MessageManager()
    var body: some Scene {
        WindowGroup {
            ContentView(messageManager: messageManager)
        }
    }
}
