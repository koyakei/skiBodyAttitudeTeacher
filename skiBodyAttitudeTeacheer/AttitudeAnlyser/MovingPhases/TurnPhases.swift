//
//  TurnPhases.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

protocol TurnPhasesProtocol:MovingPhasesProtocol{

}

struct TurnPhases:MovingPhasesProtocol{

    func turnFinished() throws -> Bool {
        <#code#>
    }


    let movingPhases: [MovingPhaseProtocol]

    func maxYawAttitudePhase() throws ->MovingPhaseProtocol{

    }
    init(movingPhases: [TurnPhaseProtocol]){
        self.movingPhases = movingPhases
    }


//    func maxRollAngle(turnPhases: [TurnPhase]) -> Double {
//        (turnPhases.max(by: { (a, b) -> Bool in
//            return a.attitude.roll < b.attitude.roll
//        })?.attitude.roll)!
//    }
    // ターンとは ロール角でうちに倒れてそのほうこうにヨーイングしていること  ピッチングは 下に向いていくのがターン前半で 上に向くのが後半 この三つの要素が合っている場合にターンが開始していると判定する
    // ロール角が0になった時に上記をチェックしよう
    // ターン三分割して 増減表を書いてやる
//    func isTurn() -> Bool{
//
//    }

    func ターン前半の角速度と姿勢が一致してますか(turnPhase: TurnPhase)-> Bool{
        let 横回転 :Double = turnPhase.rotationRate.z
        let roll : Double = turnPhase.rotationRate.y
        let pitch: Double = turnPhase.rotationRate.x
        横回転.sign == .plus //横回転が右回りだったら、
        && roll.sign == .plus // ロール角も右に倒れていっている
        && turnPhase.attitude.roll.sign == .plus //　現在のロール角も右
        && pitch.sign == .minus// ピッチングは下っていたらマイナス増えるはず
            // ねじれバーンだと　ピッチングがかなり左右非対称になる。
    }
    
    func ターン中盤の角速度と姿勢が一致してますか()-> Bool{
        
    }
    
    func ターン後半の角速度と姿勢が一致してますか()-> Bool{
        
    }
}
