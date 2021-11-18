//
//  TurnPhases.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

struct TurnPhases {

    func maxRollAngle(turnPhases: [MovingPhaseProtocol]) -> Double {
        (turnPhases.max(by: { (a, b) -> Bool in
            return a.attitude.roll < b.attitude.roll
        })?.attitude.roll)!
    }

    func ターン前半の角速度と姿勢が一致してますか(turnPhase: MovingPhaseProtocol) -> Bool {
        let 横回転: Double = turnPhase.rotationRate.z
        let roll: Double = turnPhase.rotationRate.y
        let pitch: Double = turnPhase.rotationRate.x
        return 横回転.sign == .plus //横回転が右回りだったら、
                && roll.sign == .plus // ロール角も右に倒れていっている
                && turnPhase.attitude.roll.sign == .plus //　現在のロール角も右
                && pitch.sign == .minus// ピッチングは下っていたらマイナス増えるはず
        // ねじれバーンだと　ピッチングがかなり左右非対称になる。
    }
}
