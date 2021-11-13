//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import UIKit

open class MotionEvaluaterManager: NSObject {
    var delegate : MotionFeedbackerDelegate
    // 時計からのモーションん
    // motion from board
    // motion from headphone
    // 全部混ぜて評価
//    let airPodOnHeadMiotionReceiver : AirPodOnHeadMiotionReceiver
    var boardに裏返して進行方向にX軸を向けたPhoneturnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
    init(
//        boardに裏返して進行方向にX軸を向けたPhoneturnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneturnReceiver,
         delegate: MotionFeedbackerDelegate) {
        self.delegate=delegate
//        self.boardに裏返して進行方向にX軸を向けたPhoneturnReceiver = boardに裏返して進行方向にX軸を向けたPhoneturnReceiver
    }
    
    func boardMotionReceiver(_ motion: CMDeviceMotion, _ recievedProsessUptime: TimeInterval){
        boardに裏返して進行方向にX軸を向けたPhoneturnReceiver.receiver(turnPhase: TurnPhase.init(motion, recievedProsessUptime))
        delegate.result(score: 100)
    }
}
