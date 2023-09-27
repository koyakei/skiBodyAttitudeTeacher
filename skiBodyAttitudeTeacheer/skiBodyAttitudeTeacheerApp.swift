//
//  skiBodyAttitudeTeacheerApp.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI

@main
struct skiBodyAttitudeTeacheerApp: App {
    let messageManager = MessageManager()
    var body: some Scene {
        WindowGroup {
            ContentView(messageManager: messageManager)
        }
        
    }
}
