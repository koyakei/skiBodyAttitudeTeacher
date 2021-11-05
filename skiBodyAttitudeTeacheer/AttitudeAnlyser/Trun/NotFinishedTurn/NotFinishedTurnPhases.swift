//
//  TurnPhases.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

typealias TurnSide = Bool




struct OneNotFinishedTurn{
    var turnPhases : [TurnPhase]
    var turnMaxPassed: Bool
    var turnMax: TurnPhase
    // 正方向のロール角増加がターン前半だとする
    var turnDirection = +1
    
    // 前のターンの最大ロール角はわかっている。
    // 次のターンの最大ロール角を見つける
    // ロール角5フレーム前よりも逆方向に下がっていれば、ターンマックスを超えたとする
    // それで下がっていって、前のターン最大とあとの最大のちょうど中間
    
}



