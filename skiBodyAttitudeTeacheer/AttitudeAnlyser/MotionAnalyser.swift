//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import UIKit

struct turnCorrector{
    var turnStream:[TurnPhase]
    let beforeOneturn: OneFinisedTurn
    let beforeturnMax: Double
    let afterturnMax: Double
    
    func turnCutter(turnStream: [TurnPhase])-> OneFinisedTurn {
        
    }
    
}

open class MotionEvaluaterManager: NSObject {
    var delegate : MotionFeedbackerDelegate
    // 時計からのモーションん
    // motion from board
    // motion from headphone
    // 全部混ぜて評価
//    let airPodOnHeadMiotionReceiver : AirPodOnHeadMiotionReceiver
    var boardに裏返して進行方向にX軸を向けたPhoneturnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneturnReceiver
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

struct MotionEvaluater{
    
    
    let pairOfFinishedturn : PairOfFinishedTurn
    // ターン後半のワットでかんがえるか？
}
