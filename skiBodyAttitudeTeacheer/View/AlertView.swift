//
//  AlertView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/27.
//

import SwiftUI
import MultipeerConnectivity

struct AlertView: View {
    @State var showAlert = false
    var invitationHandler : ((Bool, MCSession?) -> Void)
    var session : MCSession
    let targetDevice: String
    var body: some View {
        Button("Show Alert") {
            showAlert = true
        }
        .alert(targetDevice + "と接続", isPresented: $showAlert) {
            Button("了解") {
                invitationHandler(false, session)          // 了解ボタンが押された時の処理
            }
            Button("拒否") {
                invitationHandler(false, session)        // 了解ボタンが押された時の処理
            }
        } message: {
            Text("詳細メッセージ")
        }
    
    }
}
