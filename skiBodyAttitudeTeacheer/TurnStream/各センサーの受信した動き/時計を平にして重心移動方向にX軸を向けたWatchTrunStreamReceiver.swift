//
//  時計を平にして重心移動方向にX軸を向けたWatchturnStreamReceiver.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/31.
//

import Foundation
//var 頭につけたHeadPhoneturnStream: [turnPhase]
//var 足につけたWatchturnStream: [turnPhase]
//var Boardに裏返して進行方向にX軸を向けたPhoneturnStream: [turnPhase]
// 一ターン目はどうするのか？　蓄積ターンができるまで、我慢してそこから判定に入るか
struct 時計を平にして重心移動方向にX軸を向けたWatchturnStreamReceiver: MotionStreamReceiver{
    var turnPhases: [TurnPhase]
    
    mutating func receiver(turnPhase: TurnPhase) {
        turnPhases.append(turnPhase)
    }
    
}
